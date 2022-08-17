import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_camera_overlay/model.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../example/example_camera_overaly.dart';
import '../api/upload_image.dart';


class UseCameraPage extends StatefulWidget {
  static const routeName = '/camera-page';
  final String path;
  // const UseCameraPage({Key? key}) : super(key: key);

  const UseCameraPage(this.path);

  @override
  _UseCameraPageState createState() => _UseCameraPageState();
}

class F {
  final double x;
  final double px;
  final double multiply;
  F({
    required this.x,
    required this.px,
  }) : multiply = x * px;
}

class _UseCameraPageState extends State<UseCameraPage> {

  File? _image;
  final picker = ImagePicker();

  String galleryurl = '';


  //late final String pig_num = "ㄴㅁㅇㅁㄹ";
  //late final String birth_year, birth_month, birth_day, buy_year, buy_month, buy_day, rutting_year, rutting_month, rutting_day, et_ruting_date, delivery_date,
  //baby_meal_day,male_pig_num, baby_num_born, baby_num_survive, rutting_second, survive_baby_num, teenager_weight, estimated_delivery_date, baby_weight, memo;
  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    final temp=await submit_uploadimg(image);
    print("aaaa");
    print(temp);

    setState((){
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
    return temp;
  }

  // Future<void> loadImage() async{
  //   final ImagePicker _picker = ImagePicker();
  //
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   // if(image != null) cropImage(image.path);
  // }
  // Future<void> cropImage(String imagePath) async {
  //   const MAX_WIDTH = 1920;
  //   const MAX_HEIGHT = 1080;
  //   const COMPRESS_QUALITY = 75;
  //
  //   File? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: imagePath, // 이미지 경로
  //       maxWidth: MAX_WIDTH, // 이미지 최대 너비
  //       maxHeight: MAX_HEIGHT, // 이미지 최대 높이
  //       compressQuality: COMPRESS_QUALITY // 이미지 압축 품질
  //
  //     // . . .
  //     // 기타 property 설정
  //     // . . .
  //
  //   );
  //   if(croppedImage != null) uploadImage(croppedImage.path);
  // }
  // Future<void> uploadImage(String imagePath) async {
  //   var dio = Dio();
  //   var formData = FormData.fromMap({
  //     'image' : await MultipartFile.fromFile(imagePath)
  //   });
  //
  //   final response = await dio.post('/image/upload', data: formData);
  // }

  // 비동기 처리를 통해 (기본)카메라와 갤러리에서 이미지를 가져온다.
  // Future getImage(ImageSource imageSource) async {
  //   print("getImage");
  //   final image = await picker.pickImage(
  //       source: imageSource); // 갤러리에서 사진을 고르는 코드
  //
  //   // 사진 선택한 걸 업로드
  //   final galleryfile = await submit_uploadimg(image);
  //
  //
  //   setState(() {
  //     _image = File(image!.path); // 가져온 이미지를 내장 _image에 저장
  //   });
  //
  //   return galleryfile;
  // }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    final String cameraurl = 'http://211.107.210.141:3000/images/' + widget.path;
    print(cameraurl);

    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .width,
        child: Center(
            child: _image == null //삼항연!산!자!
                ? (widget.path == "no" ? Text('No image selected.') : Image
                .network(cameraurl))
                : galleryurl == '' ? Text('No url selected.') : Image.network(
                'http://211.107.210.141:3000/images/' + galleryurl)));
  }

  List<F> data = [];

  final xController = TextEditingController();
  final pxController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       TextField(
    //         controller: xController,
    //         decoration: const InputDecoration(hintText: "x"),
    //       ),
    //       TextField(
    //         controller: pxController,
    //         decoration: const InputDecoration(hintText: "px"),
    //       ),
    //       ElevatedButton(
    //           onPressed: () {
    //             // get Text and parse to double
    //             final xVal = xController.text.toString();
    //             final pxVal = pxController.text.toString();
    //
    //             double? x = double.tryParse(xVal);
    //             double? px = double.tryParse(pxVal);
    //
    //             if (x == null || px == null) {
    //               /// allow only number
    //               return;
    //             }
    //             // else add to data list
    //             setState(() {
    //               data.add(F(x: x, px: px));
    //             });
    //
    //             /// clear
    //             xController.clear();
    //             pxController.clear();
    //           },
    //           child: Text("ADD")),
    //       DataTable(
    //           headingRowColor:
    //           MaterialStateProperty.all(Colors.blueGrey.withOpacity(.5)),
    //           showBottomBorder: true,
    //           columns: const [
    //             DataColumn(
    //               label: Text("x"),
    //             ),
    //             DataColumn(
    //               label: Text("p(x)"),
    //             ),
    //             DataColumn(
    //               label: Text("x*p(x)"),
    //             ),
    //           ],
    //           rows: data
    //               .map(
    //                 (f) => DataRow(
    //               cells: [
    //                 DataCell(Text(f.x.toString())),
    //                 DataCell(Text(f.px.toString())),
    //                 DataCell(Text(
    //                   f.multiply.toStringAsFixed(3),
    //                 )),
    //               ],
    //             ),
    //           )
    //               .toList()),
    //     ],
    //
    //   ),
    // );
    return SingleChildScrollView(
      // backgroundColor: const Color(0xfff4f3f9),
      scrollDirection: Axis.vertical,

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.0),
                  // DataTable(
                  //     headingRowColor:
                  //     MaterialStateProperty.all(Colors.white.withOpacity(.5)),
                  //     showBottomBorder: true,
                  //     columns: const [
                  //       DataColumn(
                  //         label: Text("x"),
                  //       ),
                  //       DataColumn(
                  //         label: Text("p(x)"),
                  //       ),
                  //       DataColumn(
                  //         label: Text("x*p(x)"),
                  //       ),
                  //     ],
                  //     rows: data
                  //         .map(
                  //           (f) => DataRow(
                  //         cells: [
                  //           DataCell(Text(f.x.toString())),
                  //           DataCell(Text(f.px.toString())),
                  //           DataCell(Text(
                  //             f.multiply.toStringAsFixed(3),
                  //           )),
                  //         ],
                  //       ),
                  //     )
                  //         .toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Container(
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(80.0),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle, // 표 가운데 정렬
                    border: TableBorder(
                        // color: Colors.white,
                        // style: BorderStyle.solid,
                        // width: 2
                      verticalInside: BorderSide(width: 1.0, color: Colors.black, style: BorderStyle.solid),
                      top: BorderSide(color: Colors.black, width: 1),
                      left: BorderSide(color: Colors.black, width: 1),
                      right: BorderSide(color: Colors.black, width: 1)
                    ),
                    children: [
                      TableRow(children: [
                        Column(children: [Text('모돈번호',

                            style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(children: [
                          TextField(controller: xController,
                            decoration: const InputDecoration(hintText: ""),)
                        ]),
                        Column(children: [Text('웅돈번호',
                            style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(children: [
                          TextField(controller: xController,
                            decoration: const InputDecoration(hintText: " "),)
                        ]),
                      ]),

                      // TableRow(children: [
                      //   Column(children: [Text('출생일')]),
                      //   Column(children: [Text('')]),
                      //   Column(children: [Text('년')]),
                      //   Column(children: [Text('')]),
                      // ]),
                      // TableRow(children: [
                      //   Column(children: [Text('')]),
                      //   Column(children: [Text('월')]),
                      //   Column(children: [Text('')]),
                      //   Column(children: [Text('일')]),
                      // ]),
                      // TableRow(children: [
                      //   Column(children: [Text('Javatpoint')]),
                      //   Column(children: [Text('ReactJS')]),
                      //   Column(children: [Text('5*')]),
                      //   Column(children: [Text('')]),
                      // ]),
                      // TableRow(children: [
                      //   Column(children: [Text('Javatpoint')]),
                      //   Column(children: [Text('ReactJS')]),
                      //   Column(children: [Text('5*')]),
                      //   Column(children: [Text('')]),
                      // ]),
                      //
                    ],
                  ),
                ),

              ],

              ),
                  Row(
                    // margin: EdgeInsets.all(10),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Table(
                          defaultColumnWidth: FixedColumnWidth(45.8),
                          border: TableBorder.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.3),
                          children: [
                            TableRow(children: [
                              Column(children: [Text('출생일')
                              ]),
                              Column(children: [Text('      ')
                              ]),
                              Column(children: [Text('년')
                              ]),
                              Column(children: [Text('      ')
                              ]),
                              Column(children: [Text('월')
                              ]),
                              Column(children: [Text('      ')
                              ]),
                              Column(children: [Text('일')
                              ]),
                            ]),
                          ],
                        ),
                      ),

                    ],

                  ),
                  SizedBox(height: 10.0), // 위에 여백
                  showImage(),
                  SizedBox(
                    height: 15.0,

                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'camera',
                        child: Icon(Icons.add_a_photo),
                        tooltip: 'pick Image',
                        onPressed: ()  {
                          // getImage(ImageSource.camera);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleCameraOverlay()));
                          // print("open camera");
                        },
                      ),
                        FloatingActionButton(
                          heroTag: 'send_button',
                          child: Icon(Icons.wallpaper),
                          tooltip: 'pick Iamge',
                          onPressed: () async{
                            galleryurl = await getImage(ImageSource.gallery);
                            print("onpressed");
                            print(galleryurl);
                            // getImage(ImageSource.gallery);
                        },
                      ),
                    ])

                 ],
          ),
    );

  }
}


        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(height: 25.0),
        //     showImage(),
        //     SizedBox(
        //       height: 50.0,
        //
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //
        //           Table(
        //             children: [
        //               TableRow(children: [
        //                 TableCell(child: Text('javatpoint')),
        //                 TableCell(
        //                   child: Text('Flutter'),
        //                 ),
        //                 TableCell(child: Text('Android')),
        //                 TableCell(child: Text('MySQL')),
        //               ]),
        //               // TableRow(
        //               //     children: [
        //               //       Text("asdfas",textScaleFactor: 0.5),
        //               //       Text("Year",textScaleFactor: 0.5),
        //               //       Text("Country",textScaleFactor: 0.5),
        //               //       Text("Club Name",textScaleFactor: 0.5),
        //               //     ]
        //               // ),
        //               // TableRow(
        //               //     children: [
        //               //       Text("Ronaldo",textScaleFactor: 0.5),
        //               //       Text("1997",textScaleFactor: 0.5),
        //               //       Text("Brazil",textScaleFactor: 0.5),
        //               //       Text("Internazional",textScaleFactor: 0.5),
        //               //     ]
        //               // ),
        //               // TableRow(
        //               //     children: [
        //               //       Text("Zinedine Zidane",textScaleFactor: 0.5),
        //               //       Text("1998",textScaleFactor: 0.5),
        //               //       Text("France",textScaleFactor: 0.5),
        //               //       Text("Juventus",textScaleFactor: 0.5),
        //               //     ]
        //               // ),
        //             ],
        //           ),
        //
        //         // Table(
        //         //   children: [
        //         //     TableRow(
        //         //         children: [
        //         //           Text("OCR 모돈 현황판",textScaleFactor: 1.5),
        //         //           Text("모돈번호",textScaleFactor: 1.5),
        //         //           //Text(pig_num,textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           //Text("출생일",textScaleFactor: 1.5),
        //         //           //Text(birth_year,textScaleFactor: 1.5),
        //         //           Text("년",textScaleFactor: 1.5),
        //         //           //Text(birth_month,textScaleFactor: 1.5),
        //         //           Text("월",textScaleFactor: 1.5),
        //         //           //Text(birth_day,textScaleFactor: 1.5),
        //         //           Text("일",textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           //Text("구입일",textScaleFactor: 1.5),
        //         //           //Text(buy_year,textScaleFactor: 1.5),
        //         //           Text("년",textScaleFactor: 1.5),
        //         //           //Text(buy_month,textScaleFactor: 1.5),
        //         //           Text("월",textScaleFactor: 1.5),
        //         //          // Text(buy_day,textScaleFactor: 1.5),
        //         //           Text("일",textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           //Text("초발정일",textScaleFactor: 1.5),
        //         //           //Text(rutting_year,textScaleFactor: 1.5),
        //         //           Text("년",textScaleFactor: 1.5),
        //         //           //Text(rutting_month,textScaleFactor: 1.5),
        //         //           Text("월",textScaleFactor: 1.5),
        //         //           //Text(rutting_day,textScaleFactor: 1.5),
        //         //           Text("일",textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           Text("교배일",textScaleFactor: 1.5),
        //         //           //Text(et_ruting_date,textScaleFactor: 1.5),
        //         //           Text("분만일",textScaleFactor: 1.5),
        //         //           //Text(delivery_date,textScaleFactor: 1.5),
        //         //           Text("이유일",textScaleFactor: 1.5),
        //         //           //Text(baby_meal_day,textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           Text("웅돈번호",textScaleFactor: 1.5),
        //         //           //Text(male_pig_num,textScaleFactor: 1.5),
        //         //           Text("총산자수",textScaleFactor: 1.5),
        //         //           //Text(baby_num_born,textScaleFactor: 1.5),
        //         //           Text("이유두수",textScaleFactor: 1.5),
        //         //           //Text(baby_num_survive,textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           Text("재발확인일",textScaleFactor: 1.5),
        //         //           //Text(rutting_second,textScaleFactor: 1.5),
        //         //           Text("포유개시두수",textScaleFactor: 1.5),
        //         //           //Text(survive_baby_num,textScaleFactor: 1.5),
        //         //           Text("이유체중",textScaleFactor: 1.5),
        //         //           //Text(teenager_weight,textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //     TableRow(
        //         //         children: [
        //         //           Text("분만예정일",textScaleFactor: 1.5),
        //         //           //Text(estimated_delivery_date,textScaleFactor: 1.5),
        //         //           Text("생시체중",textScaleFactor: 1.5),
        //         //           //Text(baby_weight,textScaleFactor: 1.5),
        //         //           Text("특이사항",textScaleFactor: 1.5),
        //         //           //Text(memo,textScaleFactor: 1.5),
        //         //         ]
        //         //     ),
        //         //   ],
        //         // ),
        //         // 카메라 촬영 버튼
        //         FloatingActionButton(
        //           heroTag: 'camera',
        //           child: Icon(Icons.add_a_photo),
        //           tooltip: 'pick Iamge',
        //           onPressed: ()  {
        //             // getImage(ImageSource.camera);
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleCameraOverlay()));
        //             print("open camera");
        //           },
        //         ),
        //
        //         // 갤러리에서 이미지를 가져오는 버튼
        //         FloatingActionButton(
        //           heroTag: 'send_button',
        //           child: Icon(Icons.wallpaper),
        //           tooltip: 'pick Iamge',
        //           onPressed: () async{
        //             galleryurl = await getImage(ImageSource.gallery);
        //             print("onpressed");
        //             print(galleryurl);
        //
        //             // getImage(ImageSource.gallery);
        //
        //           },
        //         ),
//               ],
//             ))
//         )]);
//           )
//         ));
//   }
// }