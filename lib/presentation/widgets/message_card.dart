import 'package:chat_app/core/helper/date_util.dart';
import 'package:chat_app/core/media_query.dart';
import 'package:chat_app/data/api/api_services.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return message.fromId == ApiServices.user.uid
        ? _buildSendMessageCard(context)
        : _buildReceivedMessageCard(context);
  }

  _buildSendMessageCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: SizedBox(
            width: mediaQuery(context).width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: mediaQuery(context).height * 0.01,
                      horizontal: mediaQuery(context).width * 0.02),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    border: Border.all(color: Colors.blueAccent.shade700),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateUtil.getFormattedDateFromMillis(
                            context,
                            message.readTime.isNotEmpty
                                ? message.readTime
                                : message.sentTime),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery(context).width * 0.01,
                      ),
                      if (message.readTime.isNotEmpty)
                        const Icon(
                          Icons.done_all_rounded,
                          color: Colors.blueAccent,
                          size: 20,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildReceivedMessageCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: SizedBox(
            width: mediaQuery(context).width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: mediaQuery(context).height * 0.01,
                      horizontal: mediaQuery(context).width * 0.02),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade700),
                    color: Colors.lightGreen.shade500.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateUtil.getFormattedDateFromMillis(
                            context, message.readTime),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
