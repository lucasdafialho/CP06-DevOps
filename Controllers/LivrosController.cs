using Microsoft.AspNetCore.Mvc;
using SistemaBiblioteca.Models;
using SistemaBiblioteca.Services;

namespace SistemaBiblioteca.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LivrosController : ControllerBase
    {
        private readonly IMongoDbService _mongoDbService;

        public LivrosController(IMongoDbService mongoDbService)
        {
            _mongoDbService = mongoDbService;
        }

        [HttpPost]
        public async Task<ActionResult<Livro>> CriarLivro([FromBody] Livro livro)
        {
            try
            {
                var livroCriado = await _mongoDbService.CriarLivroAsync(livro);
                return CreatedAtAction(nameof(ObterLivroPorId), new { id = livroCriado.Id }, livroCriado);
            }
            catch (Exception ex)
            {
                return BadRequest($"Erro ao criar livro: {ex.Message}");
            }
        }

        [HttpGet]
        public async Task<ActionResult<List<Livro>>> ObterTodosLivros()
        {
            try
            {
                var livros = await _mongoDbService.ObterTodosLivrosAsync();
                return Ok(livros);
            }
            catch (Exception ex)
            {
                return BadRequest($"Erro ao obter livros: {ex.Message}");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Livro>> ObterLivroPorId(string id)
        {
            try
            {
                var livro = await _mongoDbService.ObterLivroPorIdAsync(id);
                if (livro == null)
                {
                    return NotFound($"Livro com ID {id} não encontrado.");
                }
                return Ok(livro);
            }
            catch (Exception ex)
            {
                return BadRequest($"Erro ao obter livro: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> AtualizarLivro(string id, [FromBody] Livro livro)
        {
            try
            {
                if (id != livro.Id)
                {
                    return BadRequest("ID da URL não corresponde ao ID do livro.");
                }

                var sucesso = await _mongoDbService.AtualizarLivroAsync(id, livro);
                if (!sucesso)
                {
                    return NotFound($"Livro com ID {id} não encontrado.");
                }

                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest($"Erro ao atualizar livro: {ex.Message}");
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletarLivro(string id)
        {
            try
            {
                var sucesso = await _mongoDbService.DeletarLivroAsync(id);
                if (!sucesso)
                {
                    return NotFound($"Livro com ID {id} não encontrado.");
                }

                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest($"Erro ao deletar livro: {ex.Message}");
            }
        }
    }
}
