using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaBiblioteca.Models
{
    [Table("Livros")]
    public class Livro
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [StringLength(300)]
        public string Titulo { get; set; } = string.Empty;

        [Required]
        public int AnoPublicacao { get; set; }

        [Required]
        [ForeignKey("Autor")]
        public int AutorId { get; set; }

        public Autor? Autor { get; set; }
    }
}
