<template>
  <div class="app-container">
    <h3>{{ $ts('systemSetting') }}</h3>
    <el-form
      ref="systemSettingForm"
      :model="systemSettingData"
      :rules="systemSettingRules"
      label-width="120px"
      style="width: 500px;"
    >
      <el-form-item :label="$ts('language')">
        <el-select v-model="systemSettingData.language" placeholder="请选择">
          <el-option
            v-for="item in languageOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item :label="$ts('docTabView')">
        <el-radio-group v-model="systemSettingData.docViewTabs">
          <el-radio :label="true">{{ $ts('enable') }}</el-radio>
          <el-radio :label="false">{{ $ts('disable') }}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click.native.prevent="handleUpdate">{{ $ts('dlgSave') }}</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
import { get_lang, set_lang } from '@/utils/i18n/common'

export default {
  data() {
    return {
      systemSettingData: {
        language: '',
        docViewTabs: false
      },
      systemSettingRules: {
      },
      languageOptions: [
        { label: '简体中文', value: 'zh' },
        { label: 'English', value: 'en' }
      ]
    }
  },
  mounted() {
    this.systemSettingData.language = get_lang()
    this.systemSettingData.docViewTabs = this.$store.state.settings.docViewTabSwitch
  },
  methods: {
    handleUpdate() {
      this.$refs.systemSettingForm.validate(valid => {
        if (valid) {
          set_lang(this.systemSettingData.language)
          this.onDocViewTabSwitch(this.systemSettingData.docViewTabs)
          location.reload()
        }
      })
    },
    getDocViewTabSwitchKey() {
      return `torna.doc.view.tab.switch`
    },
    onDocViewTabSwitch(val) {
      this.setAttr(this.getDocViewTabSwitchKey(), val)
    }
  }
}
</script>
