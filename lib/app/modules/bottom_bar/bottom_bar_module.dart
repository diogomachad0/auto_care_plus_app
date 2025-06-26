import 'package:auto_care_plus_app/app/modules/atividade/atividade_module.dart';
import 'package:auto_care_plus_app/app/modules/bottom_bar/bottom_bar_screen.dart';
import 'package:auto_care_plus_app/app/modules/conta/conta_screen.dart';
import 'package:auto_care_plus_app/app/modules/contato/contato_screen.dart';
import 'package:auto_care_plus_app/app/modules/home/home_module.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_screen.dart';
import 'package:auto_care_plus_app/app/modules/mapa/mapa_module.dart';
import 'package:auto_care_plus_app/app/modules/menu/menu_screen.dart';
import 'package:auto_care_plus_app/app/modules/sobre/sobre_screen.dart';
import 'package:auto_care_plus_app/app/modules/timeline/timeline_module.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/submodules/adicionar_veiculo/adicionar_veiculo_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/submodules/editar_veiculo/editar_veiculo_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BottomBarModule extends Module {
  @override
  void binds(Injector i) {
    i.add<AuthService>(AuthService.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const BottomBarScreen(),
      children: [
        ModuleRoute('/$homeRoute', module: HomeModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
        ModuleRoute('/$mapaRoute', module: MapaModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
        ModuleRoute('/$timeLineRoute', module: TimelineModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
        ModuleRoute('/$atividadeRoute', module: AtividadeModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
        ChildRoute('/$menuRoute', child: (context) => const MenuScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
      ],
    );

    r.child('/$veiculoRoute', child: (context) => const VeiculoScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$adicionarVeiculoRoute', child: (context) => const AdicionarVeiculoScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$editarVeiculoRoute', child: (context) => const EditarVeiculoScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$lembreteRoute', child: (context) => const LembreteScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$contatoRoute', child: (context) => const ContatoScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$sobreRoute', child: (context) => const SobreScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.child('/$contaRoute', child: (context) => const ContaScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
  }
}
