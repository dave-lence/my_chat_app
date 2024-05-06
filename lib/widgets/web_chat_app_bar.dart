import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20,top:10),
      width: MediaQuery.of(context).size.width * 0.70,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: const BoxDecoration(color: webAppBarColor, border: Border(left: BorderSide(color: dividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'), maxRadius: 15,
                  ),
                  SizedBox(width: 20,),
                  Text('Rivaan Ranawat', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(child: Text('Click here to view profile', style: TextStyle(color: Colors.grey, fontSize: 12),))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.grey,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.grey,)),
            ],
          )
        ],

      ),
    );
  }
}
