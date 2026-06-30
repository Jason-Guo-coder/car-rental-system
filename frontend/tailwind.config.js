/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // 蓝紫主色渐变 #3B83F5 → #7368F2
        brand: {
          start: '#3B83F5',
          end: '#7368F2',
          DEFAULT: '#3B83F5',
        },
        // 功能色（与 Figma 复用 token 对齐）
        ink: {
          DEFAULT: '#1f2330', // 深色主文字
          soft: '#5a5e6b', // 次级文字
          muted: '#8c8f9c', // 占位/弱文字
          label: '#8c909e', // 表头灰字 rgb(0.55,0.56,0.62)
        },
        danger: '#f24d5c', // 删除红 rgb(0.95,0.30,0.36)
        editblue: '#3a73f2', // 编辑蓝 rgb(0.23,0.45,0.95)
        rolepurple: '#7368f2', // 绑定角色紫 rgb(0.45,0.42,0.95)
        permteal: '#009999', // 权限分配 teal rgb(0,0.6,0.6)
        statusWarn: '#f5a623',
        statusOk: '#22b07d',
      },
      fontFamily: {
        sans: ['Inter', 'PingFang SC', 'Microsoft YaHei', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        glass: '20px',
        card: '18px',
        field: '12px',
      },
      boxShadow: {
        glass: '0 8px 32px rgba(60, 70, 130, 0.12)',
        'glass-sm': '0 4px 16px rgba(60, 70, 130, 0.08)',
        'glass-lg': '0 16px 48px rgba(60, 70, 130, 0.16)',
        field: '0 2px 8px rgba(60, 70, 130, 0.06)',
      },
      backgroundImage: {
        'brand-gradient': 'linear-gradient(135deg, #3B83F5 0%, #7368F2 100%)',
        'app-bg': 'linear-gradient(135deg, #eef0ff 0%, #f4f1fb 45%, #fdf2f8 100%)',
      },
      backdropBlur: {
        glass: '18px',
      },
    },
  },
  plugins: [],
}
