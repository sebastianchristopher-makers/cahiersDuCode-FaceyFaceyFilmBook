function yearOfFilm(release_date){
  return release_date.substring(0, 4);
}

let searchBox = document.getElementById("film");
searchBox.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    document.getElementById("search").click();
  }
});

function search(){
  let filmToSearch = document.getElementById("film").value;
  $.getJSON('/search-api', {filmToSearch:filmToSearch}, function (data, textStatus, jqXHR){
    let filmsSelect = document.getElementById('films');
    filmsSelect.options.length = 0;
    for(let i = 0; i < data.results.length; i++){
      let opt = document.createElement('option');

      let original_title = data.results[i].original_title;
      let year = yearOfFilm(data.results[i].release_date);
      let id = data.results[i].id;
      let overview = data.results[i].overview;

      let name = document.createTextNode(original_title + " (" + year + ")");
      opt.appendChild(name);
      opt.value = id;
      filmsSelect.appendChild(opt);

      opt.dataset.title = original_title;
      opt.dataset.year = year;
      opt.dataset.id = id;
      opt.dataset.poster_path = data.results[i].poster_path;
      opt.dataset.overview = overview;
    }
    document.getElementById("numFilms").innerHTML = "Search returned " + data.results.length + " result(s)";
    getCardInfo();
  })
  // .done(function () { alert('Request done!'); })
  .fail(function (jqxhr,settings,ex) { alert('failed, '+ ex); });
}

function getCardInfo(){
  let films = document.getElementById('films');
  let film = films.options[films.selectedIndex];

  let original_title = film.dataset.title;
  let year = film.dataset.year;
  document.getElementById("cardTitle").innerHTML = original_title + " (" + year + ")";

  let overview = film.dataset.overview;
  document.getElementById("overView").innerHTML = overview;

  let cardPoster = document.getElementById("posterImg");
  cardPoster.src = 'https://image.tmdb.org/t/p/w185/' + film.dataset.poster_path;
}

function addFilm(){
  let filmsSelect = document.getElementById('films');
  if(filmsSelect.options.length <= 0){
    alert("Nothing to add!");
  } else {
    let film = filmsSelect.options[films.selectedIndex];
    $.post('/search', {id:film.dataset.id, title:film.dataset.title, year: film.dataset.year, poster_path: film.dataset.poster_path}, function(data, status, xhr){

    })
    .done(function(data) {
      alert(film.text + ' was added to your collection.');
    })
    .fail(function(jqxhr, settings, ex) {
      alert('failed, ' + jqxhr.responseText);
    });
  }
}
