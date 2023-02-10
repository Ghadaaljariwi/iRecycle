import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'BlocCategories/bloc/category_bloc.dart';
import 'BlocCategories/cat.dart';
import 'BlocCategories/category.dart';
import 'Mycard.dart';

class categories extends StatefulWidget {
  const categories({super.key});

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  final _controller = PageController();
  final _controller2 = PageController();

  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recycling',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Tips',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/B0F2B673-2CD0-476D-9475-55670A28B2E6.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  showLocationIcon: false,
                  link:
                      'https://www.google.com/search?q=starbucks&npsic=0&rflfq=1&rldoc=1&rllag=24689410,46679714,585&tbm=lcl&sa=X&ved=2ahUKEwicv6W85vv8AhXURKQEHSfUBGAQtgN6BAgNEAE&biw=500&bih=565&dpr=1.5#rlfi=hd:;si:;mv:[[24.7191586,46.7049831],[24.6607563,46.647582299999996]];tbs:lrf:!1m4!1u3!2m2!3m1!1e1!2m1!1e3!3sIAE,lf:1,lf_ui:4',
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/B65DAAEE-5E2D-4CD4-B1FF-F054E957747C.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  link: 'google.com',
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/C2796A0C-48A4-4089-B959-7B1E6935738C.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  link: '',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Theme.of(context).primaryColorDark,
              ),
              // your preferred effect
              onDotClicked: (index) {}),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eco-Friendly Places',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' To Check Out!',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/starbucks.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  showLocationIcon: true,
                  link:
                      'https://www.google.com/search?q=starbucks&npsic=0&rflfq=1&rldoc=1&rllag=24689410,46679714,585&tbm=lcl&sa=X&ved=2ahUKEwicv6W85vv8AhXURKQEHSfUBGAQtgN6BAgNEAE&biw=500&bih=565&dpr=1.5#rlfi=hd:;si:;mv:[[24.7191586,46.7049831],[24.6607563,46.647582299999996]];tbs:lrf:!1m4!1u3!2m2!3m1!1e1!2m1!1e3!3sIAE,lf:1,lf_ui:4',
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/EmbeddedImage.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  showLocationIcon: true,
                  link:
                      'https://www.google.com/maps/place/Respire+Lounge/@24.7961687,46.6511105,15z/data=!4m6!3m5!1s0x3e2ee33c22766fe7:0xa08f10c1f63bd285!8m2!3d24.7961687!4d46.6511105!16s%2Fg%2F11qpw03pb7?hl=en',
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/1ae763f7-79dc-4044-b07d-01ab9214b830.png',
                  h: 150,
                  w: 700,
                  f: 15,
                  showLocationIcon: true,
                  link:
                      'https://www.google.com/maps/place/rootura/@24.7133418,46.6617369,15z/data=!4m2!3m1!1s0x0:0x25121738c24fcebc?sa=X&ved=2ahUKEwjY3LbhpYr9AhW68LsIHfTRCNcQ_BJ6BAhqEAg',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Theme.of(context).primaryColorDark,
              ),
              // your preferred effect
              onDotClicked: (index) {}),
          // SizedBox(
          //   height: 25,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25),
          //   child: Row(
          //     //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Matrial',
          //         style: TextStyle(
          //           fontSize: 28,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       Text(
          //         ' Categories',
          //         style: TextStyle(
          //           fontSize: 28,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: 200,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     controller: _controller2,
          //     children: [
          //       MyCard(
          //         category: 'Plastic',
          //         color: Color.fromARGB(255, 189, 232, 152),
          //         width: 150,
          //         img: 'assets/images/8BABA77D-4D45-4455-B2AA-E7346F29DB8A.png',
          //         h: 100,
          //         w: 100,
          //         f: 15,
          //         link: '',
          //         showLocationIcon: false,
          //       ),
          //       MyCard(
          //         category: 'Can',
          //         color: Color.fromARGB(255, 249, 215, 255),
          //         width: 150,
          //         img: 'assets/images/B1F516F5-24C3-49A0-9C73-DFB9C53B8A49.png',
          //         h: 100,
          //         w: 100,
          //         f: 15,
          //         link: '',
          //         showLocationIcon: false,
          //       ),
          //       MyCard(
          //         category: 'Paper',
          //         color: Color.fromARGB(255, 255, 221, 176),
          //         width: 150,
          //         img: 'assets/images/6A85129E-9AC5-4A37-9F66-CD59E22D356A.png',
          //         h: 100,
          //         w: 100,
          //         f: 15,
          //         link: '',
          //         showLocationIcon: false,
          //       ),
          //       MyCard(
          //         category: 'Glass',
          //         color: Color.fromARGB(255, 189, 232, 152),
          //         width: 150,
          //         img: 'assets/images/35293533-33CB-4941-80FE-EB4D7279E30C.png',
          //         h: 100,
          //         w: 100,
          //         f: 15,
          //         link: '',
          //         showLocationIcon: false,
          //       ),
          //       MyCard(
          //         category: 'Box',
          //         color: Color.fromARGB(255, 176, 230, 255),
          //         width: 150,
          //         img: 'assets/images/11879CE4-9519-47BE-AF87-7A21DD315EED.png',
          //         h: 100,
          //         w: 100,
          //         f: 15,
          //         link: '',
          //         showLocationIcon: false,
          //       ),
          //     ],
          //   ),

/*
            child: Container(
              width: 100,
              height: 100,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const LinearProgressIndicator();
                    }

                    return Stack(
                      children: [
                        snapshot.hasData
                            ? ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot data) {
                                  return Cat(
                                    //id = data["id"];
                                    name: data['name'],
                                    description: data['description'],
                                    image: data['image'],
                                  );
                                }).toList(),
                              )
                            : Container(
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: Colors.grey[700],
                                      size: 64,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        'There is no post',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                        // Utils.loadingCircle(_isLoading),
                      ],
                    );
                  }),
                  
            ),
            */
          // ),
        ]),
      ),
    );
    /////});
  }
}
