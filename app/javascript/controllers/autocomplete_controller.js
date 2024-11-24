// import { Controller } from "@hotwired/stimulus"

// // Connects to data-controller="autocomplete"
// export default class extends Controller {
//   static targets = ["input", "results"]

//   search() {
//     const query = this.inputTarget.value

//     fetch(`/cameras/search?query=${query}`, {
//       method: "GET",
//       headers: {
//         "Accept": "text/vnd.turbo-stream.html"
//       }
//     })
//     .then(response => response.text())
//     .then(html => {
//       this.resultsTarget.innerHTML = html
//     })
//   }
// }