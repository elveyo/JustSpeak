using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Transforms.Text;
using Services.Database;
using Services.Recommender;

namespace JustSpeak.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private readonly ApplicationDbContext _context;
        private static MLContext _mlContext = new MLContext();
        private static ITransformer? _tfidfModel;
        private static readonly object _lock = new object();

        public RecommenderService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Post>> GetTopPostsForUserAsync(int userId, int topN = 10)
        {
            await TrainTfidfModelAsync();

            var likedPosts = await _context
                .Likes.Where(l => l.UserId == userId && l.PostId != null)
                .Include(l => l.Post)
                .Select(l => l.Post!)
                .ToListAsync();

            if (!likedPosts.Any())
                return await _context.Posts.Take(topN).ToListAsync();

            foreach (var post in likedPosts)
            {
                if (post.Embedding == null || post.Embedding.Length == 0)
                {
                    post.Embedding = await GenerateEmbedding(post.Content);
                }
            }

            int vectorLength = likedPosts.First().Embedding.Length;
            float[] userVector = new float[vectorLength];

            foreach (var post in likedPosts)
                for (int i = 0; i < vectorLength; i++)
                    userVector[i] += post.Embedding[i];

            for (int i = 0; i < vectorLength; i++)
                userVector[i] /= likedPosts.Count;

            var candidatePosts = await _context
                .Posts.Where(p => !likedPosts.Select(l => l.Id).Contains(p.Id))
                .ToListAsync();

            foreach (var post in candidatePosts)
            {
                if (post.Embedding == null || post.Embedding.Length == 0)
                    post.Embedding = await GenerateEmbedding(post.Content);
            }

            var scoredPosts = candidatePosts
                .Select(p => new { Post = p, Score = CosineSimilarity(userVector, p.Embedding) })
                .OrderByDescending(x => x.Score)
                .Take(topN)
                .Select(x => x.Post)
                .ToList();

            return scoredPosts;
        }

        private async Task TrainTfidfModelAsync()
        {
            lock (_lock)
            {
                var posts = _context.Posts.ToList();
                var data = posts.Select(p => new TextData { Text = p.Content }).ToList();

                var trainingData = _mlContext.Data.LoadFromEnumerable(data);

                var pipeline = _mlContext.Transforms.Text.FeaturizeText(
                    outputColumnName: "Features",
                    inputColumnName: nameof(TextData.Text)
                );

                _tfidfModel = pipeline.Fit(trainingData);
            }
        }

        public async Task<float[]> GenerateEmbedding(string text)
        {
            var engine = _mlContext.Model.CreatePredictionEngine<TextData, TfidfVector>(
                _tfidfModel
            );
            var result = engine.Predict(new TextData { Text = text });
            return result.Features;
        }

        private float CosineSimilarity(float[] v1, float[] v2)
        {
            float dot = 0,
                normA = 0,
                normB = 0;
            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                normA += v1[i] * v1[i];
                normB += v2[i] * v2[i];
            }
            return dot / ((float)Math.Sqrt(normA) * (float)Math.Sqrt(normB) + 1e-8f);
        }

        private class TextData
        {
            public string Text { get; set; } = null!;
        }

        private class TfidfVector
        {
            public float[] Features { get; set; } = null!;
        }
    }
}
