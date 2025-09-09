using MongoDB.Bson.Serialization.Attributes;

namespace SistemaBiblioteca.Models
{
    public class Autor
    {
        [BsonElement("Nome")]
        public string Nome { get; set; } = string.Empty;

        [BsonElement("Nacionalidade")]
        public string Nacionalidade { get; set; } = string.Empty;
    }
}
