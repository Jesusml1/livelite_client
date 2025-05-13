import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Call Of Duty: Mobile',
  'Free Fire',
  'Blood Strike',
];
typedef MenuEntry = DropdownMenuEntry<String>;

enum Sky { automatico, manual }
enum TournamentType { public, private }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.automatico: const Color(0xff191970),
  Sky.manual: const Color(0xff40826d),
};

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  int _index = 0;

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;

  Sky _selectedSegment = Sky.automatico;

  TournamentType tournamentTypeView = TournamentType.public;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo torneo')),
      body: Stepper(
        currentStep: _index,
        type: StepperType.horizontal,
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },

        steps: <Step>[
          Step(
            isActive: _index == 0,
            title: const Text(''),
            content: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecciona tu torneo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Column(
                  spacing: 6,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.money_off_csred_rounded, size: 82),
                              Text(
                                'Torneo\nSin Premio',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Crea torneos sin premios y disfruta de la experiencia totalmente gratis!',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.price_check_rounded, size: 82),
                              Text(
                                'Torneo\nCon Premio',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'El creador financia integramente el premio y los jugadores participan gratis. el importe del premio se descontara de tu wallet al finalizar la creacion del mismo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Selecciona tu juego',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                DropdownMenu(
                  width: double.infinity,
                  dropdownMenuEntries: menuEntries,
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
                Text(
                  'Modalidad',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Tipo de Enfrentamiento'),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Cantidad de Jugadores'),

                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Tamaño del Equipo'),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Cantidad de Sustitutos'),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text(''),
            isActive: _index == 1,
            content: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalles del torneo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      'Nombre del torneo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextField(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      'Fecha de inicio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextField(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      'Region de registro*',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton(
                    onSelectionChanged: (p0){
                      setState(() {
                        tournamentTypeView = p0.first;
                      });
                    },
                    segments: <ButtonSegment<TournamentType>>[
                      ButtonSegment(
                        value: TournamentType.public,
                        label: Text('Publico'),
                      ),
                      ButtonSegment(
                        value: TournamentType.private,
                        label: Text('Privado'),
                      ),
                    ],
                    selected: <TournamentType>{tournamentTypeView},
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text(''),
            isActive: _index == 2,
            content: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalles de la llave',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Column(
                  spacing: 6,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.money_off_csred_rounded, size: 82),
                              Text(
                                'Eliminacion\nSimple',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Un formato de torneo tradicional donde la mitad de todos los jugadores son eliminados en cada ronda hasta que solo queda un ganador.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.price_check_rounded, size: 82),
                              Text(
                                'Doble\nEliminacion',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Los perdedores de una ronda continuan jugando en el cuadro inferior, mientras que los ganadores siguen jugando en el cuadro superior. Los jugadores quedan eliminados tras peder dos partidos.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text('Minimo'),
                          DropdownMenu(
                            dropdownMenuEntries: menuEntries,
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text('Maximo'),
                          DropdownMenu(
                            dropdownMenuEntries: menuEntries,
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Equipos por partido'),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text('Sistema de puntos'),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: menuEntries,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text('Kill'),
                          DropdownMenu(
                            dropdownMenuEntries: menuEntries,
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text('Puntos'),
                          DropdownMenu(
                            dropdownMenuEntries: menuEntries,
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text(''),
            isActive: _index == 3,
            content: Column(
              spacing: 12,
              children: [
                Column(
                  spacing: 6,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.money_off_csred_rounded, size: 82),
                              Text(
                                'Registro\nsencillo',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Los equipos pueden confirmar su lugar en cualquier momento antes de que comience el torneo.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.format_list_bulleted, size: 82),
                              Text(
                                'Registro con\ncheck-in',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Los equipos solo pueden confirmar su lugar durante el periodo de check-in configurado.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl(
                    onValueChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSegment = value;
                        });
                      }
                    },
                    groupValue: _selectedSegment,
                    children: const <Sky, Widget>{
                      Sky.automatico: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Automatico',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                      Sky.manual: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Manual',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    },
                  ),
                ),
                Text(
                  '(*Modo Automatico: El torneo se clasificara automaticament al inicio. Todas las rondas y partidos comenzaran automaticamente a la hora programada o lo antes posible.)',
                ),
                Text(
                  '(*Modo Manual: El organizador del torneo debe iniciar manualmente todas las rondas y partidos dentro de las rondas. Esto puede ser especialmente util al planificar la transmision de algunas partidas.',
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Juegos de inicio automatico',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Switch(value: false, onChanged: (value) {}),
                      ],
                    ),
                    Text(
                      'Elimina el requisito de que los jugadores se preparen en el lobby del modo Desafio y, en su lugar, inicial automaticamente todos los juegos.',
                    ),
                  ],
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Cancelar automaticamente los partidos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Switch(value: false, onChanged: (value) {}),
                      ],
                    ),
                    Text(
                      'Cancelar automaticamente los partidos al agotarse el tiempo',
                    ),
                  ],
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Cancelar automaticamente los partidos fallidos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Switch(value: false, onChanged: (value) {}),
                      ],
                    ),
                    Text(
                      'Cancela autmanticamente los partidos fallidos por tiempo muerto, por ejemplo, si ningun equipo llego a tiempo. Advertencia: Los partidos cancelados no se pueden revertir. Usar con precacucion.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _index += 1;
                      });
                    },
                    child: Text('Siguiente'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
