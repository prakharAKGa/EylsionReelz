import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CommentsButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CommentsButtonWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Ionicons.chatbubble_outline,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class CommentsSheetWidget extends StatelessWidget {
  final List<Map<String, String>> comments;

  const CommentsSheetWidget({required this.comments});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Center(
            child: Text('Comments',
            style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
            ),
          ),
      
   
          Expanded(
            child: SingleChildScrollView( 
              child: Column(
                children: comments.map((commentData) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    leading: CircleAvatar(
                      radius: 20, 
                      backgroundImage: NetworkImage('https://t4.ftcdn.net/jpg/06/34/25/63/360_F_634256300_1J563CXPkUJR2nteelgbfQxQz4MvFT5h.jpg'),
                    ),
                    title: Text(
                      commentData['userName'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
                    ),
                    subtitle: Text(
                      commentData['comment'] ?? 'No comment text',
                      style: const TextStyle(
                          color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
         
        ],
      );
    
  }
}
