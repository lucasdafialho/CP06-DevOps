using MongoDB.Driver;
using SistemaBiblioteca.Models;

namespace SistemaBiblioteca.Services
{
    public class MongoDbService : IMongoDbService
    {
        private readonly IMongoCollection<Livro> _livros;

        public MongoDbService(IConfiguration configuration)
        {
            var connectionString = configuration.GetSection("MongoDB:ConnectionString").Value;
            var databaseName = configuration.GetSection("MongoDB:DatabaseName").Value;
            var collectionName = configuration.GetSection("MongoDB:CollectionName").Value;

            var client = new MongoClient(connectionString);
            var database = client.GetDatabase(databaseName);
            _livros = database.GetCollection<Livro>(collectionName);
        }

        public async Task<List<Livro>> ObterTodosLivrosAsync()
        {
            return await _livros.Find(livro => true).ToListAsync();
        }

        public async Task<Livro?> ObterLivroPorIdAsync(string id)
        {
            return await _livros.Find(livro => livro.Id == id).FirstOrDefaultAsync();
        }

        public async Task<Livro> CriarLivroAsync(Livro livro)
        {
            await _livros.InsertOneAsync(livro);
            return livro;
        }

        public async Task<bool> AtualizarLivroAsync(string id, Livro livro)
        {
            var result = await _livros.ReplaceOneAsync(l => l.Id == id, livro);
            return result.ModifiedCount > 0;
        }

        public async Task<bool> DeletarLivroAsync(string id)
        {
            var result = await _livros.DeleteOneAsync(l => l.Id == id);
            return result.DeletedCount > 0;
        }
    }
}
