const API_KEY =''

function yearOfFilm(release_date){
  return release_date.substring(0, 4);
}

function search(){
  let filmToSearch = document.getElementById("film").value;
  $.getJSON('https://api.themoviedb.org/3/search/movie?api_key=' + API_KEY + '&language=en-US&query=' + filmToSearch + '&page=1&include_adult=false', function (response){
    let filmsSelect = document.getElementById('films');
    filmsSelect.options.length = 0;
    for(let i = 0; i < response.results.length; i++){
      let opt = document.createElement('option');
      let original_title = response.results[i].original_title;
      let year = yearOfFilm(response.results[i].release_date);
      let name = document.createTextNode(original_title + " (" + year + ")");
      let value = response.results[i].id;
      opt.appendChild( name );
      opt.value = value;
      filmsSelect.appendChild(opt);
    }
    document.getElementById("numFilms").innerHTML = "Search returned: " + response.results.length + " results";
    getCardPhoto();
  })
}

function getCardPhoto(){
  let films = document.getElementById('films');
  let filmId = films.options[films.selectedIndex].value;
  $.getJSON('https://api.themoviedb.org/3/movie/' + filmId + '?api_key=' + API_KEY + '&language=en-US', function(response){
    let original_title = response.original_title;
    let year = yearOfFilm(response.release_date);
    document.getElementById("cardTitle").innerHTML = original_title + " (" + year + ")";

    let overview = response.overview;
    document.getElementById("overView").innerHTML = overview;

    let cardPoster = document.getElementById("posterImg");
    cardPoster.src = 'https://image.tmdb.org/t/p/w185/' + response.poster_path;
  });
}

// function getPhoto(){
//   debugger;
//   let films = document.getElementById('films');
//   let filmId = films.options[films.selectedIndex].value;
//   $.getJSON('https://api.themoviedb.org/3/movie/' + filmId + '/images?api_key=' + API_KEY + '&language=en-US&include_image_language=en%2Cnull', function(response){
//     let backdrop = document.createElement("img");
//     backdrop.src = 'https://image.tmdb.org/t/p/w342/' + response.backdrops[0].file_path;
//     document.getElementById("backdrop").appendChild(backdrop);
//   });
// }
//
// function getFilm(){
//   let films = document.getElementById('films');
//   let filmId = films.options[films.selectedIndex].value;
//   $.getJSON('https://api.themoviedb.org/3/movie/' + filmId + '/images?api_key=' + API_KEY + '&language=en-US&include_image_language=en%2Cnull', function(response){
//     let poster = document.createElement("img");
//     poster.src = 'https://image.tmdb.org/t/p/w342/' + response.posters[0].file_path;
//     document.getElementById("poster").appendChild(poster);
//   });
// }
