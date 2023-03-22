alias BookSearch.Authors
alias BookSearch.Authors.Author
alias BookSearch.Books
alias BookSearch.Books.Book
alias BookSearch.Repo

# authors without books
Enum.each(1..10, fn _ ->
  Authors.create_author(%{name: Faker.Person.name()})
end)

# books without authors
Enum.each(1..10, fn _ ->
  Books.create_book(%{title: Faker.Lorem.sentence()})
end)

# Create authors and their books.
Enum.each(1..10, fn _ ->
  {:ok, author} = Authors.create_author(%{name: Faker.Person.name()})

  Enum.each(1..10, fn _ ->
    %Book{}
    |> Book.changeset(%{title: Faker.Lorem.sentence()})
    |> Ecto.Changeset.put_assoc(:author, author)
    |> Repo.insert!()
  end)
end)
