<script setup>
import { computed } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  title: {
    type: String,
    default: '',
  },
  size: {
    type: String,
    default: 'sm',
  },
})

const emit = defineEmits(['close'])

const dialogClass = computed(() => {
  if (props.size === 'lg') {
    return 'app-modal-dialog app-modal-lg'
  }
  return 'app-modal-dialog app-modal-sm'
})
</script>

<template>
  <Teleport to="body">
    <div v-if="show" class="app-modal-backdrop" @click.self="emit('close')">
      <div :class="dialogClass">
        <div class="app-modal-content">
          <div class="app-modal-header d-flex justify-content-between align-items-center">
            <h5 class="m-0">{{ title }}</h5>
            <button class="app-modal-close" type="button" @click="emit('close')">&times;</button>
          </div>
          <div class="app-modal-body">
            <slot />
          </div>
          <div v-if="$slots.footer" class="app-modal-footer">
            <slot name="footer" />
          </div>
        </div>
      </div>
    </div>
  </Teleport>
</template>
