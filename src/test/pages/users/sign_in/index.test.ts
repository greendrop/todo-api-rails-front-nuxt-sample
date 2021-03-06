import assert from 'assert'
import { createLocalVue, shallowMount } from '@vue/test-utils'
import Vue from 'vue'
import Vuetify from 'vuetify'
import VueI18n from 'vue-i18n'
import ja from '~/locales/ja'
import Index from '~/pages/users/sign_in/index.vue'

Vue.use(Vuetify)
const localVue = createLocalVue()
localVue.use(VueI18n)
const messages = { ja }
const i18n = new VueI18n({ locale: 'ja', fallbackLocale: 'ja', messages })

describe('Index', () => {
  test('renders', () => {
    const auth = {
      loginWith: jest.fn(),
      loggedIn: false
    }
    const wrapper = shallowMount(Index, {
      i18n,
      localVue,
      mocks: {
        $auth: auth
      }
    })
    assert.strictEqual(wrapper.isVisible(), true)
  })
})
