<template>
  <div>
    <el-button
      type="primary"
      size="mini"
      style="margin-bottom: 10px"
      @click="onParamAdd"
    >
      添加
    </el-button>
    <help-link style="margin-left: 20px;" to="/help?id=global" />
    <el-table
      :data="globalParams"
      border
      :header-cell-style="cellStyleSmall()"
      :cell-style="cellStyleSmall()"
    >
      <el-table-column label="参数名" prop="name" width="300px" />
      <el-table-column label="类型" prop="type" width="120px" />
      <el-table-column label="示例值" prop="example" />
      <el-table-column label="描述" prop="description" />
      <el-table-column
        label="操作"
        width="150"
      >
        <template slot-scope="scope">
          <el-link type="primary" size="mini" @click="onParamUpdate(scope.row)">修改</el-link>
          <el-popconfirm
            :title="`确定要删除 ${scope.row.name} 吗？`"
            @onConfirm="onParamDelete(scope.row)"
          >
            <el-link slot="reference" type="danger" size="mini">删除</el-link>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <!--dialog-->
    <el-dialog
      :title="dialogParamTitle"
      :visible.sync="dialogParamVisible"
      :close-on-click-modal="false"
      @close="resetForm('dialogParamForm')"
    >
      <el-form
        ref="dialogParamForm"
        :rules="dialogParamFormRules"
        :model="dialogParamFormData"
        label-width="120px"
        size="mini"
      >
        <el-form-item
          prop="name"
          label="参数名称"
        >
          <el-input v-model="dialogParamFormData.name" placeholder="参数名称" show-word-limit maxlength="50" />
        </el-form-item>
        <el-form-item
          prop="dataType"
          label="参数类型"
        >
          <el-select v-model="dialogParamFormData.type" size="mini">
            <el-option v-for="type in getTypeConfig()" :key="type" :label="type" :value="type"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item
          prop="example"
          label="示例值"
        >
          <el-input v-model="dialogParamFormData.example" placeholder="示例值" show-word-limit maxlength="200" />
        </el-form-item>
        <el-form-item
          prop="description"
          label="描述"
        >
          <el-input v-model="dialogParamFormData.description" type="textarea" placeholder="描述" show-word-limit maxlength="200" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogParamVisible = false">取 消</el-button>
        <el-button type="primary" @click="onDialogParamSave">保 存</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import HelpLink from '@/components/HelpLink'
export default {
  components: { HelpLink },
  data() {
    return {
      globalParams: [],
      moduleId: '',
      dialogParamVisible: false,
      dialogParamTitle: '',
      dialogParamFormData: {
        id: '',
        moduleId: '',
        name: '',
        type: 'string',
        example: '',
        description: ''
      },
      dialogParamFormRules: {
        name: [
          { required: true, message: '不能为空', trigger: 'blur' },
          { validator: (rule, value, callback) => {
            if (value && !/^[a-zA-Z0-9\-_]+$/.test(value)) {
              callback(new Error('格式错误，支持大小写英文、数字、-、下划线'))
            } else {
              callback()
            }
          }, trigger: 'blur' }
        ], example: [
          { required: true, message: '不能为空', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    reload(moduleId) {
      if (moduleId) {
        this.moduleId = moduleId
      }
      this.loadParams(this.moduleId)
    },
    loadParams(moduleId) {
      this.get('/module/setting/globalParams/list', { moduleId: moduleId }, resp => {
        this.globalParams = resp.data
      })
    },
    onParamAdd() {
      this.dialogParamTitle = '新增参数'
      this.dialogParamVisible = true
      this.dialogParamFormData.id = ''
    },
    onParamUpdate(row) {
      this.dialogParamTitle = '修改参数'
      this.dialogParamVisible = true
      this.$nextTick(() => {
        Object.assign(this.dialogParamFormData, row)
      })
    },
    onParamDelete(row) {
      this.post('/module/setting/globalParams/delete', row, () => {
        this.tip('删除成功')
        this.reload()
      })
    },
    onDialogParamSave() {
      this.$refs.dialogParamForm.validate((valid) => {
        if (valid) {
          const uri = this.dialogParamFormData.id ? '/module/setting/globalParams/update' : '/module/setting/globalParams/add'
          this.dialogParamFormData.moduleId = this.moduleId
          this.post(uri, this.dialogParamFormData, () => {
            this.dialogParamVisible = false
            this.reload()
          })
        }
      })
    }
  }
}
</script>