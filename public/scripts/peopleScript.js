let peopleSearchBox = document.getElementById("person");
peopleSearchBox.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    document.getElementById("search-person").click();
  }
});

function searchPerson(){
  let personToSearch = document.getElementById("person").value;
  $.getJSON('/search-people', {personToSearch:personToSearch}, function (data, textStatus, jqXHR){
    let peopleSelect = document.getElementById('people');
    peopleSelect.options.length = 0;
    for(let i = 0; i < data.results.length; i++){
      let opt = document.createElement('option');

      let name = data.results[i].name;
      let profile_path = data.results[i].profile_path

      let optName = document.createTextNode(name);
      opt.appendChild(optName);
      opt.value = i;
      people.appendChild(opt);

      opt.dataset.name = name;
      opt.dataset.profile_path = profile_path;
    }
    document.getElementById("numresults").innerHTML = "Search returned " + data.results.length + " result(s)";
    getPersonInfo();
  })
  // .done(function () { alert('Request done!'); })
  .fail(function (jqxhr,settings,ex) { alert('failed, '+ ex); });
}

function getPersonInfo(){
  let people = document.getElementById('people');
  let person = people.options[people.selectedIndex];

  let name = person.dataset.name;
  let cardProfile = document.getElementById("profileImg");
  cardProfile.src = 'https://image.tmdb.org/t/p/w185/' + person.dataset.profile_path;
}

function addProfile(){
  let peopleSelect = document.getElementById('people');
  if(peopleSelect.options.length <= 0){
    alert("Nothing to add!");
  } else {
    let person = peopleSelect.options[peopleSelect.selectedIndex];
    $.post('/update-profile', {profile_path:person.dataset.profile_path}, function(data, status, xhr){

    })
    .done(function(data) {
      alert("Your profile picture was updated");
      window.location.href = "/user_profile";
    })
    .fail(function(jqxhr, settings, ex) {
      alert('failed, ' + jqxhr.responseText);
    });
  }
}
