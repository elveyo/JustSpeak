using Services.Database;

namespace Services.Recommender
{
    public interface IRecommenderService
    {
        public Task<List<Post>> GetTopPostsForUserAsync(int userId, int topN);
        public Task<float[]> GenerateEmbedding(string text);
    }
}
