using Microsoft.EntityFrameworkCore;
using SistemaBiblioteca.Models;

namespace SistemaBiblioteca.Data
{
    public class BibliotecaDbContext : DbContext
    {
        public BibliotecaDbContext(DbContextOptions<BibliotecaDbContext> options) : base(options)
        {
        }

        public DbSet<Autor> Autores { get; set; }
        public DbSet<Livro> Livros { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Autor>(entity =>
            {
                entity.HasKey(a => a.Id);
                entity.Property(a => a.Nome).IsRequired().HasMaxLength(200);
                entity.Property(a => a.Nacionalidade).IsRequired().HasMaxLength(100);
                
                entity.HasMany(a => a.Livros)
                    .WithOne(l => l.Autor)
                    .HasForeignKey(l => l.AutorId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            modelBuilder.Entity<Livro>(entity =>
            {
                entity.HasKey(l => l.Id);
                entity.Property(l => l.Titulo).IsRequired().HasMaxLength(300);
                entity.Property(l => l.AnoPublicacao).IsRequired();
                entity.Property(l => l.AutorId).IsRequired();
            });
        }
    }
}

