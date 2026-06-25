<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :inline="true" :model="infoModel" size="small">
      <el-form-item label="厂商名称">
        <el-select v-model="infoModel.makerId" placeholder="请选择" clearable @change="handleMakerChange">
          <el-option v-for="item in makerList" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="品牌名称">
        <el-select v-model="infoModel.brandId" placeholder="请选择" clearable>
          <el-option v-for="item in brandList" :key="item.id" :label="item.brandName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="车牌号码">
        <el-input v-model="infoModel.autoNum" placeholder="请输入车牌号码" />
      </el-form-item>
      <el-form-item label="车辆类型">
        <el-select v-model="infoModel.infoType" placeholder="请选择" clearable>
          <el-option label="燃油车" :value="0" />
          <el-option label="电动车" :value="1" />
          <el-option label="混动车" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="车辆状态">
        <el-select v-model="infoModel.status" placeholder="请选择" clearable>
          <el-option label="未租" :value="0" />
          <el-option label="已租" :value="1" />
          <el-option label="维保" :value="2" />
          <el-option label="自用" :value="3" />
        </el-select>
      </el-form-item>
      <el-form-item label="租金下限">
        <el-input v-model="infoModel.lowRent" placeholder="租金下限" />
      </el-form-item>
      <el-form-item label="租金上限">
        <el-input v-model="infoModel.highRent" placeholder="租金上限" />
      </el-form-item>
      <el-form-item label="上牌日期">
        <el-date-picker
          v-model="infoModel.registrationDateVal"
          type="daterange"
          align="right"
          unlink-panels
          value-format="yyyy-MM-dd"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleAdd">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="handleDeleteBatch">批量删除</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格 -->
    <el-table :data="tableData" border stripe style="margin-bottom: 20px;" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="40" />
      <el-table-column label="序号" width="50">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="autoNum" label="车牌" width="100" />
      <el-table-column prop="makerName" label="厂商" width="110" />
      <el-table-column prop="brandName" label="品牌" width="110" />
      <el-table-column prop="infoType" label="类型" width="90">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.infoType == 0">燃油车</el-tag>
          <el-tag v-else-if="scope.row.infoType == 1" type="success">电动车</el-tag>
          <el-tag v-else-if="scope.row.infoType == 2" type="warning">混动车</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="color" label="颜色" width="80">
        <template slot-scope="scope">
          <span :style="{ background: scope.row.color, height: '20px', width: '50px', display: 'inline-block', border: '1px solid #ddd' }" />
        </template>
      </el-table-column>
      <el-table-column label="排量" width="90">
        <template slot-scope="scope">{{ scope.row.displacement + scope.row.unit }}</template>
      </el-table-column>
      <el-table-column prop="mileage" label="里程" width="90" />
      <el-table-column prop="rent" label="租金" width="80" />
      <el-table-column prop="registrationDate" label="上牌日期" width="110" />
      <el-table-column label="图片" width="90">
        <template slot-scope="scope">
          <el-image
            v-if="scope.row.pic"
            :src="scope.row.pic"
            :preview-src-list="[scope.row.pic]"
            fit="cover"
            style="width: 60px; height: 45px;"
          />
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status == 0">未租</el-tag>
          <el-tag v-else-if="scope.row.status == 1" type="success">已租</el-tag>
          <el-tag v-else-if="scope.row.status == 2" type="warning">维保</el-tag>
          <el-tag v-else-if="scope.row.status == 3" type="info">自用</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button type="primary" size="mini" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      background
      layout="total, prev, pager, next, jumper"
      :current-page="start"
      :page-size="size"
      :total="total"
      @current-change="search"
    />

    <!-- 新增/修改弹窗 -->
    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible" width="40%">
      <el-form ref="form" :model="saveInfo" :rules="rules" label-width="100px">
        <el-form-item label="所属厂商" prop="makerId">
          <el-select v-model="saveInfo.makerId" placeholder="请选择" @change="selectMaker">
            <el-option v-for="item in makerList" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属品牌" prop="brandId">
          <el-select v-model="saveInfo.brandId" placeholder="请选择">
            <el-option v-for="item in saveBrandList" :key="item.id" :label="item.brandName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="车牌号码" prop="autoNum">
          <el-input v-model="saveInfo.autoNum" placeholder="请输入车牌号码" />
        </el-form-item>
        <el-form-item label="车辆类型" prop="infoType">
          <el-radio-group v-model="saveInfo.infoType">
            <el-radio-button :label="0">燃油车</el-radio-button>
            <el-radio-button :label="1">电动车</el-radio-button>
            <el-radio-button :label="2">混动车</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="车辆颜色" prop="color">
          <el-color-picker v-model="saveInfo.color" />
        </el-form-item>
        <el-form-item label="汽车排量" prop="displacement">
          <el-input-number v-model="saveInfo.displacement" :step="0.1" :min="0" />
        </el-form-item>
        <el-form-item label="排量单位" prop="unit">
          <el-radio-group v-model="saveInfo.unit">
            <el-radio-button label="L">L</el-radio-button>
            <el-radio-button label="T">T</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="行驶里程" prop="mileage">
          <el-input-number v-model="saveInfo.mileage" :min="0" placeholder="请输入行驶里程" />
        </el-form-item>
        <el-form-item label="日租金额" prop="rent">
          <el-input-number v-model="saveInfo.rent" :min="0" placeholder="请输入日租金额" />
        </el-form-item>
        <el-form-item label="车辆押金" prop="deposit">
          <el-input-number v-model="saveInfo.deposit" :min="0" placeholder="请输入车辆押金" />
        </el-form-item>
        <el-form-item label="上牌日期" prop="registrationDate">
          <el-date-picker v-model="saveInfo.registrationDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" />
        </el-form-item>
        <el-form-item label="车辆状态" prop="status">
          <el-radio-group v-model="saveInfo.status">
            <el-radio-button :label="0">未租</el-radio-button>
            <el-radio-button :label="1">已租</el-radio-button>
            <el-radio-button :label="2">维保</el-radio-button>
            <el-radio-button :label="3">自用</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="车辆图片" prop="pic">
          <el-upload
            class="avatar-uploader"
            :action="uploadPath"
            :headers="uploadToken"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <img v-if="saveInfo.pic" :src="saveInfo.pic" class="avatar">
            <i v-else class="el-icon-plus avatar-uploader-icon" />
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import infoApi from '@/api/auto_info'
import makerApi from '@/api/auto_maker'
import brandApi from '@/api/auto_brand'
import { getToken } from '@/utils/auth'

export default {
  name: 'AutoInfoList',
  data() {
    return {
      infoModel: {},
      tableData: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      makerList: [],
      brandList: [],
      saveBrandList: [],
      dialogFormVisible: false,
      dialogStatus: 'create',
      saveInfo: {},
      uploadPath: process.env.VUE_APP_BASE_API + 'rental/oss/upload',
      uploadToken: { token: getToken() },
      titleMap: {
        create: '新增车辆',
        update: '修改车辆'
      },
      rules: {
        makerId: [{ required: true, message: '请选择所属厂商', trigger: 'change' }],
        brandId: [{ required: true, message: '请选择所属品牌', trigger: 'change' }],
        autoNum: [{ required: true, message: '请输入车牌号码', trigger: 'blur' }],
        infoType: [{ required: true, message: '请选择车辆类型', trigger: 'change' }],
        rent: [{ required: true, message: '请输入日租金额', trigger: 'blur' }],
        status: [{ required: true, message: '请选择车辆状态', trigger: 'change' }]
      }
    }
  },
  created() {
    this.searchMakerList()
    this.search()
  },
  methods: {
    async search(start = 1) {
      this.start = start
      const res = await infoApi.search(this.start, this.size, this.infoModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    searchMakerList() {
      makerApi.selectAll().then(res => {
        if (res.success) {
          this.makerList = res.data
        }
      })
    },
    // 查询表单：厂商变化时联动品牌
    handleMakerChange(val) {
      this.infoModel.brandId = undefined
      this.brandList = []
      if (val) {
        brandApi.selectByMakerId(val).then(res => {
          if (res.success) {
            this.brandList = res.data
          }
        })
      }
    },
    // 弹窗：厂商变化时联动品牌
    selectMaker(val) {
      this.saveInfo.brandId = undefined
      this.saveBrandList = []
      if (val) {
        brandApi.selectByMakerId(val).then(res => {
          if (res.success) {
            this.saveBrandList = res.data
          }
        })
      }
    },
    handleSearch() {
      if (this.infoModel.registrationDateVal !== undefined && this.infoModel.registrationDateVal !== null) {
        this.infoModel.lowRegistrationDate = this.infoModel.registrationDateVal[0]
        this.infoModel.highRegistrationDate = this.infoModel.registrationDateVal[1]
      }
      this.search(1)
    },
    resetForm() {
      this.infoModel = {}
      this.brandList = []
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    handleAdd() {
      this.saveInfo = {}
      this.saveBrandList = []
      this.dialogFormVisible = true
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.saveInfo = { ...row }
      brandApi.selectByMakerId(row.makerId).then(res => {
        if (res.success) {
          this.saveBrandList = res.data
        }
      })
      this.dialogFormVisible = true
      this.dialogStatus = 'update'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleAvatarSuccess(res, file) {
      this.saveInfo.pic = res.data
      this.$forceUpdate()
    },
    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2
      if (!isJPG) {
        this.$message.error('上传图片只能是 JPG 或 PNG 格式!')
      }
      if (!isLt2M) {
        this.$message.error('上传图片大小不能超过 2MB!')
      }
      return isJPG && isLt2M
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await infoApi.save(this.saveInfo)
          if (res.success) {
            this.$message({ message: '保存成功', type: 'success' })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await infoApi.update(this.saveInfo)
          if (res.success) {
            this.$message({ message: '修改成功', type: 'success' })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    },
    handleDelete(row) {
      this.$confirm('此操作将永久删除该信息, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        infoApi.delete(row.id).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    },
    handleDeleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message({ message: '请选择要删除的数据', type: 'warning' })
        return
      }
      this.$confirm('此操作将永久删除选中数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        infoApi.delete(this.multipleSelection).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}
.avatar {
  width: 100px;
  height: 100px;
  display: block;
}
</style>
