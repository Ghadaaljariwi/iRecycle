import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCard extends StatelessWidget {
  final String category;
  final color;
  final img;
  final double width;
  final double h;
  final double w;
  final double f;
  final String link;
  final bool showLocationIcon;
  const MyCard({
    Key? key,
    required this.category,
    this.color,
    this.img,
    required this.width,
    required this.h,
    required this.w,
    required this.f,
    required this.link,
    this.showLocationIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: AssetImage(
                  img,
                ),
                height: h,
                width: w,
              ),
            ),
            Center(
              child: Text(
                category.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: f),
              ),
            ),
            if (showLocationIcon)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: InkWell(
                    splashColor: Colors.grey,
                    highlightColor: Colors.grey[100],
                    borderRadius: BorderRadius.circular(50),
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(link))) {
                        await launchUrl(Uri.parse(link));
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// class MyCard extends StatelessWidget {
//   final String category;
//   final color;
//   final img;
//   final double width;
//   final double h;
//   final double w;
//   final double f;
//   final String link;
//   final bool showLocationIcon;
//   const MyCard(
//       {Key? key,
//       required this.category,
//       this.color,
//       this.img,
//       required this.width,
//       required this.h,
//       required this.w,
//       required this.f,
//       required this.link,
//       this.showLocationIcon = true})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Container(
//         width: width,
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Image(
//                   image: AssetImage(
//                     img,
//                   ),
//                   height: h,
//                   width: w,
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   category.toString(),
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: f),
//                 ),
//               ),
//               if (showLocationIcon)
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 20, bottom: 20),
//                     child: InkWell(
//                       splashColor: Colors.grey,
//                       highlightColor: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(50),
//                       onTap: () async {
//                         if (await canLaunchUrl(Uri.parse(link))) {
//                           await launchUrl(Uri.parse(link));
//                         } else {
//                           throw 'Could not launch $link';
//                         }
//                       },
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Icon(
//                           Icons.location_on,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: InkWell(
//                   onTap: () async {
//                     if (await canLaunchUrl(Uri.parse(link))) {
//                       await launchUrl(Uri.parse(link));
//                     } else {
//                       throw 'Could not launch $link';
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 2,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(5),
//                       child: Icon(
//                         Icons.location_on,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
