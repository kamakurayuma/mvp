// import { Controller } from "@hotwired/stimulus"
// import Autocomplete from "stimulus-autocomplete"

// export default class extends Controller {
//   connect() {
//     new Autocomplete(this.element, {
//       // サーバーから取得するURLを指定
//       search: (query) => this.search(query),
//       // 結果を表示するための関数
//       result: (item) => {
//         // 結果を表示するロジックを実装
//         console.log(item)
//       },
//     })
//   }

//   async search(query) {
//     const response = await fetch(`/search?query=${query}`)
//     return response.json()
//   }
// }