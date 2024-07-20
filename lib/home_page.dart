import 'package:flutter/material.dart';
import 'package:hive_data_base/boxes/boxes.dart';
import 'package:hive_data_base/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController=TextEditingController();
  final descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive Data'),),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getdata().listenable(),
        builder: (context,box,_){
          var data=box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                            Spacer(),
                            InkWell(
                              onTap: (){
                                updateDialogBox(data[index],data[index].title,data[index].description);
                              },
                                child: Icon(Icons.edit,color: Colors.black,)),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                deleteItem(data[index]);
                              },
                                child: Icon(Icons.delete,color: Colors.red,))
                          ],
                        ),
                        Text(data[index].description),
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          showDialogBox(context);
          //

          /*var box=await Hive.openBox('akram');//file name,box is a file
          box.put('name', 'Akram Khan');//key,value
          box.put('age', 25);
          box.put('profession', {
            'profile':'Developer',
            'company':'NIC',
            'location':'New Delhi'
          });
          print(box.get('name'));
          print(box.get('age'));
          print(box.get('profession'));
          print(box.get('profession')['company']);*/
        },
        child: Icon(Icons.add),
      ),
    );

  }

  void showDialogBox(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    final data=NotesModel(title: titleController.text, description: descriptionController.text);
                     final _box=Boxes.getdata();
                     _box.add(data);
                     data.save();
                     titleController.clear();
                     descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Add')
              ),
            ],
          );
        }
    );
  }

  void deleteItem(NotesModel notesModel)async{
    await notesModel.delete();

  }
  void updateItem(NotesModel notesModel)async{
   // await notesModel.up();

  }


  Future<void> updateDialogBox(NotesModel notesModel,String title,String description)async{
     titleController.text=title;
     descriptionController.text=description;
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Update Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    notesModel.title=titleController.text;//todo update...
                    notesModel.description=descriptionController.text;
                    notesModel.save();
                    Navigator.pop(context);
                  },
                  child: Text('Update')
              ),
            ],
          );
        }
    );
  }
}
