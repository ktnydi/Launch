export default class Like {
  constructor(state) {
    this.state = state
    this.authenticity_token = document.getElementsByName('csrf-token')[0].content
    this.clear_id = null
  }

  get _state() {
    return this.state
  }

  setState(new_state) {
    this.state = Object.assign(this.state, new_state)
  }

  fadeInLabel() {
    const label = document.getElementById('add-like-count')

    if (!label.hasAttribute('add')) {
      label.setAttribute('add', '')
    }

    clearTimeout(this.clear_id)
    
    this.clear_id = setTimeout(()=>{
      label.removeAttribute('add')
    }, 3000)
  }

  create(entry_token) {
    const url = `/entries/${entry_token}/likes`

    fetch(url, {
      method: 'POST',
      mode: 'same-origin',
      headers: {
        'Content-Type': 'application/json; charset=urf-8'
      },
      body: JSON.stringify({
        entry_token: entry_token,
        authenticity_token: this.authenticity_token,
        count: this.state.add_like_count + 1
      })
    })
    .then((response) => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok.')
    })
    .then((responseJSON) => {
      this.setState({
        sum_like_count: this.state.sum_like_count + 1,
        add_like_count: this.state.add_like_count + 1
      })
      this.state.parent_elem.innerHTML = this.render()
      this.fadeInLabel()
    })
    .catch((error) => console.error('error:', error))
  }

  update(entry_token) {
    if (this.state.add_like_count === 50) {
      this.state.parent_elem.innerHTML = this.render()
      this.fadeInLabel()
      return false
    }
    const url = `/entries/${entry_token}/likes`

    fetch(url, {
      method: 'PUT',
      mode: 'same-origin',
      headers: {
        'Content-Type': 'application/json; charset=urf-8'
      },
      body: JSON.stringify({
        entry_token: entry_token,
        authenticity_token: this.authenticity_token,
        count: this.state.add_like_count + 1
      })
    })
    .then((response) => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok.')
    })
    .then((responseJSON) => {
      this.setState({
        sum_like_count: this.state.sum_like_count + 1,
        add_like_count: this.state.add_like_count + 1
      })
      this.state.parent_elem.innerHTML = this.render()
      this.fadeInLabel()
    })
    .catch((error) => console.error('error:', error))
  }

  render() {
    const add_like_count = this.state.add_like_count < 50
    ? `+ ${this.state.add_like_count}`
    : 'Max'
  
    return(
      `<div class="entry-page__like-count">` +
        `<span>${this.state.sum_like_count}</span>` +
      `</div>` +
      `<div class="entry-page__add-like-label" id="add-like-count">` +
        `<span class="entry-page__add-like-count">` +
          `${add_like_count}` +
        `</span>` +
      `</div>` +
      `<div class="entry-page__liked">` +
        `<i class="far fa-heart"></i>` +
      `</div>`
    )
  }
}