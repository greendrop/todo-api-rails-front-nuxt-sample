<template lang="pug">
  v-layout(row wrap)
    v-flex(xs12 sm12 md12)
      v-layout(row wrap)
        v-flex(xs12 sm12 md12 mb-1)
          v-breadcrumbs(:items="breadcrumbItems")

    v-flex(xs12 sm12 md12)
      v-layout(row wrap)
        v-flex(xs12 sm12 md12 mb-3)
          .headline
            | {{ $t('labels.editModel', { model: $t('models.task') }) }}

    template(v-if="taskLoading")
      v-flex(xs12 sm12 md12)
        .text-xs-center
          v-progress-circular(indeterminate)
    template(v-else)
      task-edit-component(:task.sync="task")
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
import { Context } from '@nuxt/types'
import TaskEditComponent from '~/components/organisms/TaskEditComponent.vue'
import { ITask, Task } from '~/models/task'
import { TasksStore } from '~/store'

@Component({
  components: { TaskEditComponent },
  middleware: 'auth',
  async asyncData(context: Context, options = {}) {
    const tasksStore = options.tasksStore || TasksStore
    const data = {
      task: new Task(),
      taskLoading: false,
      requestGetTask: false
    }
    if (process.client) {
      data.requestGetTask = true
    } else {
      await tasksStore.getTaskById({ id: parseInt(context.route.params.id) })
      if (!tasksStore.got) {
        context.app.$nuxt.error({
          statusCode: tasksStore.errorStatus || 500,
          message: tasksStore.errorData || ''
        })
      }
      data.task = tasksStore.task
      data.taskLoading = false
    }
    return data
  }
})
export default class Edit extends Vue {
  tasksStore = TasksStore
  task: ITask = new Task()
  taskLoading: boolean = false
  requestGetTask: boolean = false

  async mounted() {
    if (this.requestGetTask) {
      await this.getTask()
    }
  }

  get breadcrumbItems(): { [key: string]: any }[] {
    const id = this.$route.params.id
    return [
      {
        text: this.$i18n.t('labels.home'),
        to: '/',
        exact: true,
        disabled: false
      },
      {
        text: this.$i18n.t('labels.listModel', {
          model: this.$i18n.t('models.task')
        }),
        to: '/tasks',
        exact: true,
        disabled: false
      },
      {
        text: this.$i18n.t('labels.showModel', {
          model: this.$i18n.t('models.task')
        }),
        to: `/tasks/${id}`,
        exact: true,
        disabled: false
      },
      {
        text: this.$i18n.t('labels.editModel', {
          model: this.$i18n.t('models.task')
        }),
        to: `/tasks/${id}/edit`,
        exact: true,
        disabled: true
      }
    ]
  }

  async getTask() {
    this.taskLoading = true
    await this.tasksStore.getTaskById({ id: parseInt(this.$route.params.id) })

    if (!this.tasksStore.got) {
      this.$nuxt.error({
        statusCode: this.tasksStore.errorStatus || 500,
        message: this.tasksStore.errorData || ''
      })
    }

    this.task = this.tasksStore.task
    this.taskLoading = false
  }
}
</script>
