// Get the <span> element that closes the modal
window.onload = function(){
  let spans = document.getElementsByClassName("close");
}
spans = document.getElementsByClassName("close");
// let spans = document.getElementsByClassName("close")
for(let i = 0; i < document.getElementsByClassName("close").length; i++){
  spans[i].onclick = function() {
    this.parentElement.parentElement.style.display = "none";
  }
}

// When the user clicks the button, open the modal
function openAddReview(id){
  let modal = document.getElementById("myModal" + id);
  modal.style.display = "block";
}

// When the user clicks anywhere outside of the modal, close it
// window.onclick = function(event) {
//   if (event.target == modal) {
//     modal.style.display = "none";
//   }
// }

function deleteWatched(userId, filmId){
  $.post('/delete-watched', {userId:userId,filmId:filmId}, function(data){})
  alert("Removed from list");
  location.reload()
}

function deleteToWatch(userId, filmId){
  $.post('/delete-to-watch', {userId:userId,filmId:filmId}, function(data){})
  alert("Removed from list");
  location.reload()
}
