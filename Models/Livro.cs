using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace SistemaBiblioteca.Models
{
    public class Livro
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; } = string.Empty;

        [BsonElement("Titulo")]
        public string Titulo { get; set; } = string.Empty;

        [BsonElement("AnoPublicacao")]
        public int AnoPublicacao { get; set; }

        [BsonElement("Autor")]
        public Autor Autor { get; set; } = new Autor();
    }
}
