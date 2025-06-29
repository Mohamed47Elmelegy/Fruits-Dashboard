import '../Data/model/reviews_model.dart';

num getAvgRating(List<ReviewsModel> reviews) {
  if (reviews.isEmpty) return 0;

  num totalRating = 0;
  for (var review in reviews) {
    totalRating += review.rating;
  }

  return totalRating / reviews.length;
}
