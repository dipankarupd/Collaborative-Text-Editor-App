String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays <= 7) {
    return '${difference.inDays} days ago';
  } else {
    return 'more than a week ago';
  }
}
