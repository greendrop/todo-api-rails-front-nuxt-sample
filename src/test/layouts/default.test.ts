import assert from 'assert'
import { createLocalVue, shallowMount } from '@vue/test-utils'
import Vue from 'vue'
import Vuetify from 'vuetify'
import VueI18n from 'vue-i18n'
import ja from '~/locales/ja'
import Default from '~/layouts/default.vue'

Vue.use(Vuetify)
const localVue = createLocalVue()
localVue.use(VueI18n)
const messages = { ja }
const i18n = new VueI18n({ locale: 'ja', fallbackLocale: 'ja', messages })

describe('Default', () => {
  test('renders', () => {
    const wrapper = shallowMount(Default, {
      i18n,
      localVue,
      stubs: {
        nuxt: true
      }
    })
    assert.strictEqual(wrapper.isVisible(), true)
  })
})
