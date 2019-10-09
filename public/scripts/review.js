// Get the modal
let modal = document.getElementById("myModal");

// Get the <span> element that closes the modal
let span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal
function openAddReview(id){
  let modal = document.getElementById("myModal" + id);
  modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

function deleteWatched(userId, filmId){
  $.post('/delete-watched', {userId:userId,filmId:filmId}, function(data){})
  alert("Removed from list");
}

function deleteToWatch(userId, filmId){
  $.post('/delete-to-watch', {userId:userId,filmId:filmId}, function(data){})
  alert("Removed from list");
}
