import { router } from '@kit.ArkUI';
import { CommonTopBar } from '../common/Widgets';

interface AgreementParams {
  type: string;
}

interface Clause {
  title: string;
  body: string;
}

const PRIVACY_CLAUSES: Clause[] = [
  {
    title: '一、引言',
    body: '「校膳通」由校膳通开发团队开发，是一款面向校园场景的食堂避峰、在线点餐与光盘积分助手（演示版）。' +
      '我们非常重视您的个人信息保护，并依据《中华人民共和国个人信息保护法》等法律法规制定本政策。'
  },
  {
    title: '二、我们收集和使用的信息',
    body: '本应用当前版本不收集、不上传任何个人信息。您在应用内主动填写的校园卡余额备注、常用地址、口味偏好，' +
      '以及使用过程中产生的积分、优惠券、光盘打卡与下单记录，均仅保存在您的设备本地（应用私有存储），' +
      '不会传输到我们的服务器或任何第三方。'
  },
  {
    title: '三、设备权限使用说明',
    body: '本应用当前版本不申请相机、位置、通讯录、麦克风等敏感权限。应用内的「餐后拍照识别」为演示流程，' +
      '不会真实调用相机，也不会采集或上传任何图像。'
  },
  {
    title: '四、信息存储与删除',
    body: '上述本地数据仅保存在您的设备中。您可以在「我的 → 设置 → 清除本地数据」中一键删除全部本地记录；' +
      '卸载本应用后，相关数据将一并被系统删除。'
  },
  {
    title: '五、信息对外提供',
    body: '我们不会出售、出租或以任何其他方式向第三方提供您的信息。本应用未集成任何第三方广告或数据统计 SDK。'
  },
  {
    title: '六、未成年人保护',
    body: '若您是未成年人，请在监护人的陪同和同意下阅读本政策并使用本应用。'
  },
  {
    title: '七、您的权利',
    body: '您可以随时在「我的 → 设置」中撤回隐私授权、清除本地数据。撤回授权后，我们将不再处理您的信息，' +
      '本应用的部分功能将不可用。'
  },
  {
    title: '八、政策更新',
    body: '本政策如有更新，我们会在应用内以弹窗等形式再次向您展示并重新征得您的同意。'
  },
  {
    title: '九、联系我们',
    body: '如对本政策或个人信息保护有任何疑问、意见或投诉，请通过「我的 → 联系客服」与我们联系，' +
      '我们将在 3 个工作日内回复。'
  }
];

const TERMS_CLAUSES: Clause[] = [
  {
    title: '一、服务说明',
    body: '「校膳通」为您提供校园食堂拥挤度查询、在线点餐、光盘打卡与积分记录的演示功能。'
  },
  {
    title: '二、演示数据声明',
    body: '本应用为演示与学习用途。当前版本展示的食堂、窗口、菜品、排队人数、销量、积分、优惠券及排行榜等数据' +
      '均为演示数据，不接入任何真实校园系统，也不产生真实的餐费支付、扣款与出餐行为。' +
      '请以学校后勤部门发布的官方信息为准。'
  },
  {
    title: '三、账号与使用规范',
    body: '本应用无需注册账号即可使用，不设真实账户体系。您应合法、正当地使用本应用，' +
      '不得利用本应用从事任何违法违规活动。'
  },
  {
    title: '四、知识产权',
    body: '本应用的界面设计、图标、文字与代码的知识产权归开发者所有。'
  },
  {
    title: '五、免责声明',
    body: '在法律允许的最大范围内，因使用或无法使用本应用而产生的任何直接或间接损失，开发者不承担赔偿责任。'
  },
  {
    title: '六、协议变更',
    body: '我们可能会适时更新本协议，更新后将在应用内提示。继续使用即视为您接受更新后的协议。'
  },
  {
    title: '七、联系我们',
    body: '如对本协议有任何疑问，请通过「我的 → 联系客服」与我们联系。'
  }
];

@Entry
@Component
struct AgreementPage {
  @State isTerms: boolean = false;

  aboutToAppear(): void {
    const p = router.getParams();
    if (p !== null && p !== undefined) {
      const param = p as AgreementParams;
      this.isTerms = param.type === 'terms';
    }
  }

  private clauses(): Clause[] {
    return this.isTerms ? TERMS_CLAUSES : PRIVACY_CLAUSES;
  }

  build() {
    Column() {
      CommonTopBar({ title: this.isTerms ? '用户服务协议' : '隐私政策', showBack: true })

      Scroll() {
        Column({ space: 14 }) {
          Column({ space: 6 }) {
            Text(this.isTerms ? '《校膳通用户服务协议》' : '《校膳通隐私政策》')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.c_text_primary'))
              .width('100%')
            Text('更新日期：2026 年 9 月 27 日　生效日期：2026 年 9 月 27 日')
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
              .width('100%')
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          ForEach(this.clauses(), (c: Clause) => {
            Column({ space: 6 }) {
              Text(c.title)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
                .width('100%')
              Text(c.body)
                .fontSize(12)
                .lineHeight(20)
                .fontColor($r('app.color.c_text_body'))
                .width('100%')
            }
            .width('100%')
            .padding(14)
            .backgroundColor($r('app.color.c_card_bg'))
            .borderRadius(12)
          }, (c: Clause) => c.title)

          Text('校膳通开发团队')
            .fontSize(11)
            .fontColor($r('app.color.c_text_tertiary'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 4, bottom: 16 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .backgroundColor($r('app.color.c_page_bg'))
    }
    .width('100%')
    .height('100%')
  }
}