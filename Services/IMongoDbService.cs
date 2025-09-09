using SistemaBiblioteca.Models;

namespace SistemaBiblioteca.Services
{
    public interface IMongoDbService
    {
        Task<List<Livro>> ObterTodosLivrosAsync();
        Task<Livro?> ObterLivroPorIdAsync(string id);
        Task<Livro> CriarLivroAsync(Livro livro);
        Task<bool> AtualizarLivroAsync(string id, Livro livro);
        Task<bool> DeletarLivroAsync(string id);
    }
}
