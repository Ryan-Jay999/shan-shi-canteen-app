import { router } from '@kit.ArkUI';
import { pasteboard } from '@kit.BasicServicesKit';
import { CommonTopBar, DemoNotice } from '../common/Widgets';

// 客服联系方式（如需更换为学校/团队的官方邮箱，仅需修改此常量）
const SUPPORT_EMAIL = '3304923586@qq.com';
const FEEDBACK_URL = 'https://github.com/Ryan-Jay999/shan-shi-canteen-app/issues';

interface Faq {
  q: string;
  a: string;
}

const FAQS: Faq[] = [
  {
    q: '点餐下单后真的能取到餐吗？',
    a: '不能。当前版本为演示版，下单、取餐号与取餐进度均为演示流程，不会真实出餐，也不会产生任何扣款。'
  },
  {
    q: '积分和优惠券可以真实使用吗？',
    a: '积分与优惠券为应用内的演示数据，仅用于展示错峰就餐与光盘激励机制的交互效果，不可用于真实消费。'
  },
  {
    q: '食堂拥挤度和排队人数是怎么来的？',
    a: '当前展示的均为演示数据，用于展示避峰提醒的效果。如后续版本接入真实数据源，我们会在应用内明确说明。'
  },
  {
    q: '「餐后拍照识别」会上传我的照片吗？',
    a: '不会。该功能为演示流程，不会调用相机，也不会采集或上传任何图像。'
  },
  {
    q: '如何清除我的本地数据？',
    a: '进入「我的 → 设置 → 清除本地数据」，即可一键清除积分、订单、优惠券与您填写的资料。'
  },
  {
    q: '反馈问题多久能回复？',
    a: '我们会在 3 个工作日内通过您留下的联系方式回复。'
  }
];

@Entry
@Component
struct SupportPage {
  @State openIndex: number = -1;

  private toast(msg: string): void {
    this.getUIContext().getPromptAction().showToast({ message: msg });
  }

  private copy(text: string, label: string): void {
    const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    pasteboard.getSystemPasteboard().setData(data).then(() => {
      this.toast(`${label}已复制`);
    }).catch(() => {
      this.toast('复制失败，请手动记录');
    });
  }

  build() {
    Column() {
      CommonTopBar({ title: '联系客服', showBack: true })

      Scroll() {
        Column({ space: 14 }) {
          DemoNotice({ text: '本应用为演示版本，不含真实客服工单系统。如需反馈，请通过下方渠道联系我们。' })

          // 联系方式
          Column({ space: 12 }) {
            Row() {
              Text('客服邮箱')
                .fontSize(14)
                .fontColor($r('app.color.c_text_primary'))
                .layoutWeight(1)
              Text(SUPPORT_EMAIL)
                .fontSize(12)
                .fontColor($r('app.color.c_text_secondary'))
                .maxLines(1)
            }
            .width('100%')

            Row({ space: 10 }) {
              Text('复制邮箱')
                .fontSize(13)
                .fontColor($r('app.color.c_brand'))
                .backgroundColor($r('app.color.c_brand_bg'))
                .padding({ left: 12, right: 12, top: 7, bottom: 7 })
                .borderRadius(16)
                .onClick(() => {
                  this.copy(SUPPORT_EMAIL, '客服邮箱');
                })
              Text('复制反馈链接')
                .fontSize(13)
                .fontColor($r('app.color.c_brand'))
                .backgroundColor($r('app.color.c_brand_bg'))
                .padding({ left: 12, right: 12, top: 7, bottom: 7 })
                .borderRadius(16)
                .onClick(() => {
                  this.copy(FEEDBACK_URL, '反馈链接');
                })
            }
            .width('100%')

            Text(`反馈链接：${FEEDBACK_URL}`)
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
              .width('100%')

            Text('服务时间：工作日 09:00 - 17:00')
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
              .width('100%')
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          // 常见问题
          Column({ space: 0 }) {
            Text('常见问题')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.c_text_primary'))
              .width('100%')
              .padding({ bottom: 10 })

            ForEach(FAQS, (f: Faq, idx: number) => {
              Column({ space: 8 }) {
                Row() {
                  Text(f.q)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.c_text_primary'))
                    .layoutWeight(1)
                  Text(this.openIndex === idx ? '−' : '+')
                    .fontSize(15)
                    .fontColor($r('app.color.c_text_tertiary'))
                }
                .width('100%')
                .onClick(() => {
                  this.openIndex = this.openIndex === idx ? -1 : idx;
                })

                if (this.openIndex === idx) {
                  Text(f.a)
                    .fontSize(12)
                    .lineHeight(19)
                    .fontColor($r('app.color.c_text_body'))
                    .width('100%')
                    .backgroundColor($r('app.color.c_surface_soft'))
                    .padding(10)
                    .borderRadius(8)
                }
              }
              .width('100%')
              .padding({ top: 10, bottom: 10 })
              .border(idx === FAQS.length - 1 ? {} : { width: { bottom: 1 }, color: $r('app.color.c_divider') })
            }, (f: Faq, idx: number) => f.q + idx.toString())
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          Text('如对个人信息保护有疑问，也可在「我的 → 设置」中查看《校膳通隐私政策》')
            .fontSize(11)
            .fontColor($r('app.color.c_text_tertiary'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/AgreementPage', params: { type: 'privacy' } });
            })
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