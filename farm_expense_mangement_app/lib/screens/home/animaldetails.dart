
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/cattle.dart';
import '../../services/database/cattledatabase.dart';

class AnimalDetails extends StatefulWidget {
  final String rfid;
  const AnimalDetails({super.key, required this.rfid});


  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _streamController;

  // late DocumentSnapshot<Map<String,dynamic>> snapshot;
  late DatabaseServicesForCattle cattleDb;
  late Cattle cattle;

  final List<Map<String, Object>> events = [
    {"event": "abortion", "date": "2022-01-01"},
    {"event": "vaccination", "date": "2022-02-01"},
    {"event": "heifer", "date": "2022-03-01"},
    {"event": "insemination", "date": "2022-04-01"},
    {"event": "vaccination", "date": "2027-04-01"},
    {"event": "vaccination", "date": "2027-04-01"},

  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);

    _streamController = _fetchCattleDetail();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _fetchCattleDetail() {
    return cattleDb.infoFromServer(widget.rfid).asStream();
  }

  void editCattleDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnimalDetail(cattle: cattle)));
  }

  void deleteCattle() {
    cattleDb
        .deleteCattle(widget.rfid)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Deleted'),
                duration: Duration(seconds: 2),
              ),
            ));
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AnimalList()));
  }

  @override
  Widget build(BuildContext context) {

    Widget buildWidget(Map<String,Object> event) {
      if (event['event'].toString() == 'abortion') {
        return Image.asset(
          'asset/Cross_img.png',
          width: 30,
          height: 35,
        );
      } else if (event['event'].toString() == 'vaccination') {
        return Image.asset(
          'asset/Vaccination.png',
          width: 30,
          height: 35,
        );
      } else if (event['event'].toString() == 'heifer') {
        return Image.asset(
          'asset/heifer.png',
          width: 30,
          height: 35,
        );
      } else {
        return Image.asset(
          'asset/Vaccination.png',
          width: 30,
          height: 35,
        );
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rfid,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(13, 152, 186, 1.0),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                deleteCattle();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                editCattleDetail();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )),
        ],
      ),
      body: StreamBuilder(
          stream: _streamController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Please Wait ..'),
              );
            } else if (snapshot.hasData) {
              cattle = Cattle.fromFireStore(snapshot.requireData, null);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: Text("Details",style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20),),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5,10,10,10),
                          child: Row(

                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Expanded(
                                child: Card(
                                margin: const EdgeInsets.fromLTRB(20,10,20,10),
                                // color: Colors.blue[100],
                                //   color: Color.fromRGBO(242, 210, 189, 0.7),
                                  color: Colors.green[300],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // shape: const RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.all(Radius.circular(10))),
                                      // color: Colors.white,
                                      color: Colors.green[300],
                                      // color: Color.fromRGBO(242, 210, 189, 0.7),
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: Text(
                                          "${cattle.age}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Age",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                                                        ),
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  // color: Colors.blue[100],
                                  color: const Color.fromRGBO(255, 102, 102, 0.8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // shape: const RoundedRectangleBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(12))),
                                        // color: Colors.blue[100],
                                        color: const Color.fromRGBO(255, 102, 102, 0.6),
                                        margin: const EdgeInsets.all(8),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                          child: Text(
                                            cattle.sex,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Gender",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(20,10,20,10),
                                  color: Colors.purple[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // shape: const RoundedRectangleBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(12))),
                                        color: Colors.purple[200],
                                        margin: const EdgeInsets.all(8),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                          child: Text(
                                            "${cattle.weight}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Weight",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(20,10,20,10),
                                  color: Colors.orange[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Container(
                                        // shape: const RoundedRectangleBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(12))),
                                        color: Colors.orange[300],
                                        margin: const EdgeInsets.all(8),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                          child: Text(
                                            cattle.breed,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Breed",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(20,10,20,10),
                                  color:  const Color.fromRGBO(102,178,255,1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // shape: const RoundedRectangleBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(12))),
                                        color:  const Color.fromRGBO(102,178,255,1),

                                        margin: const EdgeInsets.all(8),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                          child: Text(
                                            cattle.breed,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(20,10,20,10),
                                  color:Colors.pink[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(12))),
                                        color: Colors.pink[200],
                                        margin: const EdgeInsets.all(8),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                          child: Text(
                                            cattle.breed,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Source of Cattle",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("History",style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20),),
                            ElevatedButton(onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AddEventPopup();
                                },
                              );
                            },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:const Color.fromRGBO(13, 166, 186, 0.5)// background color
                                  // foregroundColor: Colors.white, // foreground color
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(10.0), // rounded corners
                                  // ),
                                  // padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // padding
                                ),
                                child:const Text("Add Event",
                                style: TextStyle(
                                  color:Colors.white
                                ),)
                            )
                          ],
                        ),
                      ),
                  ),
                  Expanded(
                    flex: 10,
                      // child:SingleChildScrollView(
                      //   scrollDirection: Axis.vertical,
                        child: ListView(
                          children: events
                              .map((event) => Padding(
                              padding: const EdgeInsets.fromLTRB(10,7,10,7),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromRGBO(13, 166, 186, 0.5)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [

                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                      width: 130,
                                      height: 60,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: buildWidget(event)

                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Text(
                                          " ${capitalizeFirstLetterOfEachWord(event['event'].toString())}",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      // width: 80,
                                      child: Text(
                                        event["date"].toString(), // Display the raw date string
                                        softWrap: false,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     print("Deleting item");
                                  //     // Implement deletion logic here
                                  //   },
                                  //   child: const Icon(
                                  //     Icons.delete,
                                  //     color: Colors.red,
                                  //     size: 24,
                                  //   ),
                                  // ),
                                  ],
                                  ),
                                ),
                              )
                          ).toList(),
                        ),
                    // ),

                    ),



                    // GridView(
                    //
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       crossAxisSpacing: 0, // Spacing between columns
                    //       childAspectRatio: 1.5),
                    //
                    //   children: [
                    //             Card(
                    //               margin: EdgeInsets.fromLTRB(20,20,20,20),
                    //               color: Colors.blue[100],
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                     // shape: const RoundedRectangleBorder(
                    //                     //     borderRadius:
                    //                     //     BorderRadius.all(Radius.circular(10))),
                    //                     // color: Colors.white,
                    //                     color: Colors.blue[100],
                    //
                    //                     margin: const EdgeInsets.all(8),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    //                       child: Text(
                    //                         "${cattle.age}",
                    //                         style: const TextStyle(
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 16,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const Text(
                    //                     "Age",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             Card(
                    //               margin: EdgeInsets.all(20),
                    //               color: Colors.blue[100],
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                     // shape: const RoundedRectangleBorder(
                    //                     //     borderRadius:
                    //                     //     BorderRadius.all(Radius.circular(12))),
                    //                     color: Colors.blue[100],
                    //                     margin: const EdgeInsets.all(8),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    //                       child: Text(
                    //                         cattle.sex,
                    //                         style: const TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const Text(
                    //                     "Gender",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //
                    //
                    //
                    //
                    //   ],
                    // ),
                    //
                    //
                ],
              );
            } else {
              return const Center(
                child: Text('Error in fetch'),
              );
            }
          }),
    );
  }
}

class EditAnimalDetail extends StatefulWidget {
  final Cattle cattle;

  const EditAnimalDetail({super.key, required this.cattle});

  @override
  State<EditAnimalDetail> createState() => _EditAnimalDetailState();
}

class _EditAnimalDetailState extends State<EditAnimalDetail> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _rfidTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _breedTextController = TextEditingController();
  // final TextEditingController _tagNumberController3 = TextEditingController();

  String? _selectedGender; // Variable to store selected gender
  final TextEditingController _birthDateController = TextEditingController();
  String? _selectedSource;
  String? _selectedStage;

  // Variable to store selected gender

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> sourceOptions = [
    'Born on Farm',
    'Purchased'
  ]; // List of gender options
  final List<String> stageOptions = [
    'Milked',
    'Heifer',
    'Insemination',
    'Abortion',
    'Dry',
    'Calved'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked.day.toString() != _birthDateController.text) {
      setState(() {
        _birthDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late final DatabaseServicesForCattle cattleDb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cattleDb = DatabaseServicesForCattle(uid);
    _breedTextController.text = widget.cattle.breed;
    _weightTextController.text = widget.cattle.weight.toString();
  }

  void updateCattleButton(BuildContext context) {
    final cattle = Cattle(
        rfid: widget.cattle.rfid,
        age: 4,
        breed: _breedTextController.text,
        sex: _selectedGender.toString(),
        weight: int.parse(_weightTextController.text),
        state: _selectedStage.toString());

    cattleDb.infoToServerSingleCattle(cattle);

    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AnimalDetails(
                  rfid: widget.cattle.rfid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Cattle ${widget.cattle.rfid}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AnimalDetails(rfid: widget.cattle.rfid)));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    hintText: "YYYY-MM-DD",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _weightTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter The Weight',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedSource,
                  decoration: InputDecoration(
                    labelText: 'Source of Cattle*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: sourceOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Source';
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  controller: _breedTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter The Breed',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedStage,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: stageOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStage = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process the data
                        // For example, save it to a database or send it to an API
                        updateCattleButton(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Cattle Details updated Successfully!!')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color.fromRGBO(13, 166, 186, 1.0),
                          ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _rfidTextController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}

String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) return "";

  var words = input.toLowerCase().split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }
  return words.join(' ');
}

class AddEventPopup extends StatefulWidget {
  const AddEventPopup({super.key});

  @override
  State<AddEventPopup> createState() => _AddEventPopupState();
}

class _AddEventPopupState extends State<AddEventPopup> {
  String? selectedOption;
  List<String> eventOptions = ['Abortion', 'Vaccination', 'Heifer', 'Insemination'];
  DateTime?  selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close the dialog when tapping outside the content
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            const Text(
              'Add Event',
              style: TextStyle(
                fontSize: 22.0,
                // backgroundColor: Color.fromRGBO(13, 152, 186, 1.0),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                items: eventOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10.0),

            // TextField(
            //   onChanged: (value) {
            //     selectedDate = value;
            //   },
            //   decoration: InputDecoration(
            //     hintText: 'Event Date',
            //   ),
            // ),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                  text: selectedDate != null
                      ? selectedDate.toString().split(' ')[0]
                      : ''),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              decoration: const InputDecoration(
                hintText: 'Event Date',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement submit action here
                print('Event: $selectedOption, Date: $selectedDate');
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// class AddEventPopup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }
//
//
//   contentBox(BuildContext context) {
//     List<String> eventOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
//     String selectedOption = eventOptions.first;
//     return Center(
//       child: Container(
//         padding: EdgeInsets.all(20.0),
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               'Add Event',
//               style: TextStyle(
//                 fontSize: 22.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 15.0),
//             // TextField(
//             //   decoration: InputDecoration(
//             //     hintText: 'Event Name',
//             //   ),
//             // ),
//             DropdownButton<String>(
//               value: selectedOption,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedOption = newValue;
//                 });
//               },
//               items: eventOptions.map((String option) {
//                 return DropdownMenuItem<String>(
//                   value: option,
//                   child: Text(option),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 10.0),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Event Date',
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement submit action here
//                 Navigator.of(context).pop();
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }