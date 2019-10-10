function createFilm(id){
  let film = document.getElementById(id);
  $.post('/create', {id:film.dataset.id, title:film.dataset.title, year: film.dataset.year, poster_path: film.dataset.poster_path, backdrop_path:film.dataset.backdrop_path, overview:film.dataset.overview}, function(data, status, xhr){
  })
  .done(function(data) {
    window.location.replace("/films/" + film.dataset.id);
  })
  .fail(function (jqxhr,settings,ex) { alert('failed, '+ ex); });
}
