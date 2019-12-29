import assert from 'assert'
import { createLocalVue, shallowMount } from '@vue/test-utils'
import Vue from 'vue'
import Vuetify from 'vuetify'
import VueI18n from 'vue-i18n'
import ja from '~/locales/ja'
import Index from '~/pages/tasks/_id/index.vue'
import { Task } from '~/models/task'

Vue.use(Vuetify)
const localVue = createLocalVue()
localVue.use(VueI18n)
const messages = { ja }
const i18n = new VueI18n({ locale: 'ja', fallbackLocale: 'ja', messages })

describe('Index', () => {
  test('renders', () => {
    const task = new Task()
    const route = {
      params: {
        id: task.id
      }
    }
    const wrapper = shallowMount(Index, {
      i18n,
      localVue,
      mocks: {
        task,
        $route: route
      }
    })
    assert.strictEqual(wrapper.isVisible(), true)
  })
})
