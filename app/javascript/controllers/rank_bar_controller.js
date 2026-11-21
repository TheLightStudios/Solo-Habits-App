import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { percent: Number }

  connect() {
    // Começa vazia
    this.element.style.height = "0%"

    // Espera o navegador desenhar a barra vazia antes de subir.
    // Sem isso, ele já mostraria a altura final, sem animação.
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.height = `${this.percentValue}%`
      })
    })
  }
}