import 'dart:async';
import 'dart:convert';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZGlvZ29tYWNoYWRvIiwiYSI6ImNtYjc2dXkwaDA3NGUyam4wMnJ4cHJyc2MifQ.UCZ3qN_mb80hb82sa6jmog';

class MapboxPlaceSearch extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(String address, double lat, double lng)? onPlaceSelected;
  final Function(String)? onChanged;

  const MapboxPlaceSearch({
    Key? key,
    required this.controller,
    required this.label,
    this.onPlaceSelected,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MapboxPlaceSearch> createState() => _MapboxPlaceSearchState();
}

class _MapboxPlaceSearchState extends State<MapboxPlaceSearch> with ThemeMixin {
  List<MapboxPlace> _suggestions = [];
  bool _isLoading = false;
  bool _isLocating = false;
  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.removeListener(() {
      setState(() {});
    });
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final place = _suggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(
                            place.placeName,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            place.context,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {
                            widget.controller.text = place.placeName;
                            widget.onPlaceSelected?.call(
                              place.placeName,
                              place.latitude,
                              place.longitude,
                            );
                            _removeOverlay();
                            _focusNode.unfocus();
                            setState(() {
                              _suggestions.clear();
                            });
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onSearchChanged(String query) {
    widget.onChanged?.call(query);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length > 2) {
        _searchPlaces(query);
      } else {
        setState(() {
          _suggestions.clear();
        });
        _removeOverlay();
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json'
          '?access_token=$MAPBOX_ACCESS_TOKEN'
          '&country=BR'
          '&language=pt'
          '&limit=5';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        setState(() {
          _suggestions = features.map((feature) {
            final coordinates = feature['center'] as List;
            final placeName = feature['place_name'] as String;
            final context = feature['context'] != null ? (feature['context'] as List).map((c) => c['text']).join(', ') : '';
            return MapboxPlace(
              placeName: placeName,
              latitude: coordinates[1].toDouble(),
              longitude: coordinates[0].toDouble(),
              context: context,
            );
          }).toList();
          _isLoading = false;
        });
        if (_suggestions.isNotEmpty && _focusNode.hasFocus) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      } else {
        if (mounted) {
          DialogError.show(context, 'Erro na API Mapbox: ${response.statusCode} - ${response.body}', StackTrace.current);
        }
        setState(() {
          _suggestions.clear();
          _isLoading = false;
        });
        _removeOverlay();
      }
    } catch (e, s) {
      if (mounted) {
        DialogError.show(context, 'Erro na busca Mapbox: ${e.toString()}', s);
      }
      setState(() {
        _isLoading = false;
        _suggestions.clear();
      });
      _removeOverlay();
    }
  }

  Future<void> _getCurrentLocationAndReverseGeocode() async {
    if (_isLocating || _isLoading) return;

    setState(() {
      _isLocating = true;
      _removeOverlay();
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          DialogError.show(context, 'Serviços de localização desabilitados. Por favor, habilite-os.', StackTrace.current);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            DialogError.show(context, 'Permissão de localização negada. Não é possível obter a localização.', StackTrace.current);
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          DialogError.show(context, 'Permissão de localização negada permanentemente. Vá para as configurações do aplicativo para habilitar.', StackTrace.current);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lng = position.longitude;

      final address = await _reverseGeocode(lat, lng);

      if (address != null) {
        widget.controller.text = address;
        widget.onPlaceSelected?.call(address, lat, lng);
        _focusNode.unfocus();
      } else {
        if (mounted) {
          DialogError.show(context, 'Não foi possível encontrar o endereço para a localização atual.', StackTrace.current);
        }
      }
    } catch (e, s) {
      if (mounted) {
        DialogError.show(context, 'Erro ao obter localização: ${e.toString()}. Verifique as permissões e o GPS.', s);
      }
    } finally {
      setState(() {
        _isLocating = false;
      });
    }
  }

  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json'
          '?access_token=$MAPBOX_ACCESS_TOKEN'
          '&country=BR'
          '&language=pt'
          '&limit=1';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        if (features.isNotEmpty) {
          return features[0]['place_name'] as String;
        }
      } else {
        if (mounted) {
          DialogError.show(context, 'Erro na API de Geocodificação Reversa Mapbox: ${response.statusCode} - ${response.body}', StackTrace.current);
        }
      }
    } catch (e, s) {
      if (mounted) {
        DialogError.show(context, 'Erro na geocodificação reversa: ${e.toString()}', s);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _focusNode.hasFocus || widget.controller.text.isNotEmpty ? colorScheme.primary : Colors.grey[600],
            ),
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorScheme.primary, width: 1)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: _isLoading || _isLocating
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.secondary,
                      ),
                    ),
                  )
                : _focusNode.hasFocus
                    ? IconButton(
                        icon: const Icon(Icons.my_location_sharp),
                        onPressed: _getCurrentLocationAndReverseGeocode,
                      )
                    : const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class MapboxPlace {
  final String placeName;
  final double latitude;
  final double longitude;
  final String context;

  MapboxPlace({
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.context,
  });
}
