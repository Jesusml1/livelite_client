import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livelite_client/modules/models/tournament_create_request.dart';

const List<String> games = <String>[
  'Call Of Duty: Mobile',
  'Free Fire',
  'Blood Strike',
];

const List<String> confrontationTypes = <String>['Battle Royal', 'Teams'];
const List<String> teamSizes = <String>[
  '2 jugadores',
  '4 jugadores',
  '8 jugadores',
  '10 jugadores',
];

const List<String> substitutesAmount = <String>[
  '2 jugadores',
  '4 jugadores',
  '8 jugadores',
  '10 jugadores',
];

const List<String> regions = <String>['Venezuela', 'Colombia', 'Brasil', 'USA'];

const List<String> pointSystem = <String>[
  '1:300',
  '2:200',
  '3:100',
  '4:50',
  '5:25',
  '6:10',
  '7:5',
];

typedef MenuEntry = DropdownMenuEntry<String>;

enum TournamentMode { withPrize, withoutPrize }

enum TournamentType { public, private }

enum CondutionMode { auto, manual }

enum TournamentEliminationMode { singleElimination, doubleElimination }

enum TournamentRegistrationType { simpleRegistration, checkInRegistration }

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  int _index = 0;

  DateTime? _dateSelected;
  TimeOfDay? _timeSelected;

  TournamentMode _selectedMode = TournamentMode.withoutPrize;
  TournamentEliminationMode _selectedEliminationMode =
      TournamentEliminationMode.singleElimination;
  TournamentRegistrationType _selectedRegistrationType =
      TournamentRegistrationType.simpleRegistration;

  static final List<MenuEntry> _gamesEntries = UnmodifiableListView<MenuEntry>(
    games.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String _gamesDropdownvalue = games.first;

  static final List<MenuEntry> _confrontationTypeEntries =
      UnmodifiableListView<MenuEntry>(
        confrontationTypes.map<MenuEntry>(
          (String name) => MenuEntry(value: name, label: name),
        ),
      );
  String _confrontationTypeDropdownvalue = confrontationTypes.first;

  static final List<MenuEntry> _teamSizesEntries =
      UnmodifiableListView<MenuEntry>(
        teamSizes.map<MenuEntry>(
          (String name) => MenuEntry(value: name, label: name),
        ),
      );
  String _teamSizeDropdownvalue = confrontationTypes.first;

  static final List<MenuEntry> _substitutesAmountEntries =
      UnmodifiableListView<MenuEntry>(
        substitutesAmount.map<MenuEntry>(
          (String name) => MenuEntry(value: name, label: name),
        ),
      );
  String _substitutesAmountDropdownvalue = confrontationTypes.first;

  static final List<MenuEntry> _regionEntries = UnmodifiableListView<MenuEntry>(
    confrontationTypes.map<MenuEntry>(
      (String name) => MenuEntry(value: name, label: name),
    ),
  );
  String _regionDropdownvalue = confrontationTypes.first;

  static final List<MenuEntry> _pointSystemEntries =
      UnmodifiableListView<MenuEntry>(
        pointSystem.map<MenuEntry>(
          (String name) => MenuEntry(value: name, label: name),
        ),
      );

  String _pointSystemDropdownValue = pointSystem.first;

  TournamentType _tournamentTypeView = TournamentType.public;
  CondutionMode _condutionModeView = CondutionMode.auto;

  bool _autoStartMatch = false;
  bool _autoCancelMatch = false;
  bool _autoCancelFailedMatch = false;

  late TextEditingController _playersAmountTEC;
  late TextEditingController _tournamentNameTEC;
  late TextEditingController _minPlayersTEC;
  late TextEditingController _maxPlayersTEC;
  late TextEditingController _teamsPerMatchTEC;
  late TextEditingController _pointsPerKillTEC;
  late TextEditingController _dateSelectedTEC;
  late TextEditingController _timeSelectedTEC;

  @override
  void initState() {
    super.initState();
    _playersAmountTEC = TextEditingController();
    _tournamentNameTEC = TextEditingController();
    _minPlayersTEC = TextEditingController();
    _maxPlayersTEC = TextEditingController();
    _teamsPerMatchTEC = TextEditingController();
    _pointsPerKillTEC = TextEditingController();
    _dateSelectedTEC = TextEditingController();
    _timeSelectedTEC = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _playersAmountTEC.dispose();
    _tournamentNameTEC.dispose();
    _minPlayersTEC.dispose();
    _maxPlayersTEC.dispose();
    _teamsPerMatchTEC.dispose();
    _pointsPerKillTEC.dispose();
    _dateSelectedTEC.dispose();
    _timeSelectedTEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear torneo')),
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
          // Step 1
          // Seleccion de torneo
          Step(
            isActive: _index == 0,
            title: Text(_index == 0 ? 'Torneo' : ''),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona tu torneo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Column(
                      spacing: 6,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMode = TournamentMode.withoutPrize;
                            });
                          },
                          child: Card(
                            color:
                                _selectedMode == TournamentMode.withoutPrize
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.money_off_csred_rounded,
                                      size: 82,
                                    ),
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
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMode = TournamentMode.withPrize;
                            });
                          },
                          child: Card(
                            color:
                                _selectedMode == TournamentMode.withPrize
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                        ),
                      ],
                    ),
                    Text(
                      'Selecciona tu juego',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    DropdownMenu(
                      width: double.infinity,
                      dropdownMenuEntries: _gamesEntries,
                      initialSelection: games.first,
                      onSelected: (String? value) {
                        setState(() {
                          _gamesDropdownvalue = value!;
                        });
                      },
                    ),
                    Text(
                      'Modalidad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text('Tipo de Enfrentamiento'),
                        DropdownMenu(
                          width: double.infinity,
                          dropdownMenuEntries: _confrontationTypeEntries,
                          initialSelection: confrontationTypes.first,
                          onSelected: (String? value) {
                            setState(() {
                              _confrontationTypeDropdownvalue = value!;
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
                        TextField(
                          controller: _playersAmountTEC,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
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
                          dropdownMenuEntries: _teamSizesEntries,
                          initialSelection: teamSizes.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _teamSizeDropdownvalue = value!;
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
                          dropdownMenuEntries: _substitutesAmountEntries,
                          initialSelection: substitutesAmount.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _substitutesAmountDropdownvalue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Step 2
          // Detalles del torneo
          Step(
            title: Text(_index == 1 ? 'Detalles' : ''),
            isActive: _index == 1,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del torneo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text(
                          'Nombre del torneo*',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextField(controller: _tournamentNameTEC),
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
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dateSelectedTEC,
                                onTap: () async {
                                  if (Platform.isIOS) {
                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 300,
                                          width: double.infinity,
                                          color: CupertinoColors
                                              .systemBackground
                                              .resolveFrom(context),
                                          child: SafeArea(
                                            top: false,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged: (date) {
                                                setState(() {
                                                  _dateSelected = date;
                                                  _dateSelectedTEC.text =
                                                      '${date.day}/${date.month}/${date.year}';
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  final dateSelected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (dateSelected != null) {
                                    setState(() {
                                      _dateSelected = dateSelected;
                                      _dateSelectedTEC.text =
                                          '${dateSelected.day}/${dateSelected.month}/${dateSelected.year}';
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'dd/mm/aaaa',
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _timeSelectedTEC,
                                onTap: () async {
                                  if (Platform.isIOS) {
                                    await showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 300,
                                          width: double.infinity,
                                          color: CupertinoColors
                                              .systemBackground
                                              .resolveFrom(context),
                                          child: SafeArea(
                                            top: false,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged: (date) {
                                                setState(() {
                                                  _timeSelected = TimeOfDay(
                                                    hour: date.hour,
                                                    minute: date.minute,
                                                  );
                                                  _timeSelectedTEC.text =
                                                      '${date.hour}:${date.minute}';
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  final timeSelected = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (timeSelected != null) {
                                    setState(() {
                                      _timeSelected = timeSelected;
                                      _timeSelectedTEC.text =
                                          '${timeSelected.hour}:${timeSelected.minute}';
                                    });
                                  }
                                },
                                decoration: InputDecoration(hintText: 'hh:mm'),
                              ),
                            ),
                          ],
                        ),
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
                          dropdownMenuEntries: _regionEntries,
                          initialSelection: regions.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _regionDropdownvalue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text(
                          'Modo de admisión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton(
                            onSelectionChanged: (p0) {
                              setState(() {
                                _tournamentTypeView = p0.first;
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
                            selected: <TournamentType>{_tournamentTypeView},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Step 3
          // Detalles de la llave
          Step(
            title: Text(_index == 2 ? 'Llave' : ''),
            isActive: _index == 2,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles de la llave',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Column(
                      spacing: 6,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedEliminationMode =
                                  TournamentEliminationMode.singleElimination;
                            });
                          },
                          child: Card(
                            color:
                                _selectedEliminationMode ==
                                        TournamentEliminationMode
                                            .singleElimination
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.money_off_csred_rounded,
                                      size: 82,
                                    ),
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
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedEliminationMode =
                                  TournamentEliminationMode.doubleElimination;
                            });
                          },
                          child: Card(
                            color:
                                _selectedEliminationMode ==
                                        TournamentEliminationMode
                                            .doubleElimination
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                        ),
                      ],
                    ),
                    Text(
                      'Cantidad de equipos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Text('Minimo'),
                              TextField(
                                controller: _minPlayersTEC,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                decoration: InputDecoration(
                                  hintText: 'ej. 2-10',
                                ),
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
                              TextField(
                                controller: _maxPlayersTEC,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                decoration: InputDecoration(
                                  hintText: 'ej. 10-20',
                                ),
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
                        TextField(
                          controller: _teamsPerMatchTEC,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
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
                          dropdownMenuEntries: _pointSystemEntries,
                          initialSelection: pointSystem.first,
                          onSelected: (String? value) {
                            setState(() {
                              _pointSystemDropdownValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      'El sistema de puntos se puede modifiar para adaptarse mejor al formato de su torneo.',
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text('Puntos por kill'),
                        TextField(
                          controller: _pointsPerKillTEC,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Step 4
          // Registro y cronograma
          Step(
            title: Text(_index == 3 ? 'Cronograma' : ''),
            isActive: _index == 3,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Registro y cronograma',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Column(
                      spacing: 6,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRegistrationType =
                                  TournamentRegistrationType.simpleRegistration;
                            });
                          },
                          child: Card(
                            color:
                                _selectedRegistrationType ==
                                        TournamentRegistrationType
                                            .simpleRegistration
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.money_off_csred_rounded,
                                      size: 82,
                                    ),
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
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRegistrationType =
                                  TournamentRegistrationType
                                      .checkInRegistration;
                            });
                          },
                          child: Card(
                            color:
                                _selectedRegistrationType ==
                                        TournamentRegistrationType
                                            .checkInRegistration
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                        ),
                      ],
                    ),
                    const Text(
                      'Modo de conducción',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        width: double.infinity,
                        child: SegmentedButton(
                          onSelectionChanged: (p0) {
                            setState(() {
                              _condutionModeView = p0.first;
                            });
                          },
                          segments: <ButtonSegment<CondutionMode>>[
                            ButtonSegment(
                              value: CondutionMode.auto,
                              label: Text('Automatico'),
                            ),
                            ButtonSegment(
                              value: CondutionMode.manual,
                              label: Text('Manual'),
                            ),
                          ],
                          selected: <CondutionMode>{_condutionModeView},
                        ),
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
                            Switch(
                              value: _autoStartMatch,
                              onChanged: (value) {
                                setState(() {
                                  _autoStartMatch = value;
                                });
                              },
                            ),
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
                            Switch(
                              value: _autoCancelMatch,
                              onChanged: (value) {
                                setState(() {
                                  _autoCancelMatch = value;
                                });
                              },
                            ),
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
                            Switch(
                              value: _autoCancelFailedMatch,
                              onChanged: (value) {
                                setState(() {
                                  _autoCancelFailedMatch = value;
                                });
                              },
                            ),
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
            ),
          ),
        ],
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                if (_index == 0)
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ),
                if (_index > 0)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _index -= 1;
                        });
                      },
                      child: Text('Atras'),
                    ),
                  ),
                if (_index <= 2)
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
                if (_index > 2)
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_dateSelectedTEC.text.isEmpty ||
                            _timeSelectedTEC.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor, selecciona una fecha y hora.',
                              ),
                            ),
                          );
                          return;
                        }
                        final requestPayload = TournamentCreateRequest(
                          mode: _selectedMode.name,
                          game: _gamesDropdownvalue,
                          confrontationType: _confrontationTypeDropdownvalue,
                          playersAmount: _playersAmountTEC.text,
                          teamSize: _teamSizeDropdownvalue,
                          substitutesAmount: _substitutesAmountDropdownvalue,
                          name: _tournamentNameTEC.text,
                          date:
                              '${_dateSelected?.year}-${_dateSelected?.month}-${_dateSelected?.day}',
                          time:
                              '${_timeSelected?.hour}:${_timeSelected?.minute}',
                          region: _regionDropdownvalue,
                          admissionMode: _tournamentTypeView.name,
                          eliminationType: _selectedEliminationMode.name,
                          minTeams: int.parse(_minPlayersTEC.text),
                          maxTeams: int.parse(_maxPlayersTEC.text),
                          teamsPerMatch: int.parse(_teamsPerMatchTEC.text),
                          pointSystem: _pointSystemDropdownValue,
                          pointsPerKill: int.parse(_pointsPerKillTEC.text),
                          registrationType: _selectedRegistrationType.name,
                          condutionMode: _condutionModeView.name,
                          autoStartMatch: _autoStartMatch,
                          autoCancelMatch: _autoCancelMatch,
                          autoCancelFailedMatch: _autoCancelFailedMatch,
                        );
                        print(requestPayload.toJson());
                      },
                      child: Text('Crear torneo'),
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
