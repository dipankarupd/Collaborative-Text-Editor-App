import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/features/docs/views/widgets/document_action_button.dart';
import 'package:app/utils/format_date.dart';
import 'package:flutter/material.dart';

class DocumentContainer extends StatelessWidget {
  final Document document;

  const DocumentContainer({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Title
            Text(
              document.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Author Name
            Text(
              document.author.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),

            // Last Modified
            Text(
              'Last Modified: ${formatDate(document.updatedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),

            Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: DocumentActionButton(
                    width: double.infinity,
                    height: 36,
                    text: 'Share',
                    icon: Icons.share,
                    backgroundColor: Colors.blue.shade600,
                    onPress: () {
                      // TODO: Implement share functionality
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DocumentActionButton(
                    width: double.infinity,
                    height: 36,
                    text: 'Download',
                    icon: Icons.download,
                    backgroundColor: Colors.green.shade600,
                    onPress: () {
                      // TODO: Implement download functionality
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
