import { bundleManager } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { OrderInfo, PointRecord } from '../common/Model';
import { CartManager } from '../common/Store';
import { CommonTopBar } from '../common/Widgets';

interface SettingRow {
  icon: string;
  title: string;
  desc: string;
  action: string;
}

const DATA_ROWS: SettingRow[] = [
  { icon: '🧹', title: '清除本地数据', desc: '删除积分、订单与个人资料', action: 'clear' },
  { icon: '🔒', title: '撤回隐私授权', desc: '撤回后需重新阅读并同意隐私政策', action: 'revoke' }
];

const DOC_ROWS: SettingRow[] = [
  { icon: '📄', title: '隐私政策', desc: '', action: 'privacy' },
  { icon: '📘', title: '用户服务协议', desc: '', action: 'terms' }
];

@Entry
@Component
struct SettingsPage {
  @StorageLink('privacyAgreed') privacyAgreed: boolean = false;
  @State version: string = '1.0.0';

  aboutToAppear(): void {
    try {
      const info = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      this.version = info.versionName;
    } catch (err) {
      this.version = '1.0.0';
    }
  }

  private toast(msg: string): void {
    this.getUIContext().getPromptAction().showToast({ message: msg });
  }

  private doClear(): void {
    AppStorage.setOrCreate('cart', new CartManager());
    AppStorage.setOrCreate('points', 0);
    AppStorage.setOrCreate('records', [] as PointRecord[]);
    AppStorage.setOrCreate('streak', 0);
    AppStorage.setOrCreate('plateDone', false);
    AppStorage.setOrCreate('doneTasks', [] as string[]);
    AppStorage.setOrCreate('lastOrder', null as OrderInfo | null);
    AppStorage.setOrCreate('cardValue', '');
    AppStorage.setOrCreate('address', '');
    AppStorage.setOrCreate('taste', '');
    this.toast('本地数据已清除');
  }

  private confirmClear(): void {
    this.getUIContext().showAlertDialog({
      title: '清除本地数据',
      message: '将删除本机保存的积分、优惠券、订单与个人资料，且不可恢复。确定继续吗？',
      primaryButton: {
        value: '取消',
        action: () => {
        }
      },
      secondaryButton: {
        value: '确定清除',
        fontColor: '#D93A3A',
        action: () => {
          this.doClear();
        }
      }
    });
  }

  private confirmRevoke(): void {
    this.getUIContext().showAlertDialog({
      title: '撤回隐私授权',
      message: '撤回后，您需要重新阅读并同意《校膳通隐私政策》后才能继续使用本应用。确定撤回吗？',
      primaryButton: {
        value: '取消',
        action: () => {
        }
      },
      secondaryButton: {
        value: '确定撤回',
        fontColor: '#D93A3A',
        action: () => {
          this.privacyAgreed = false;
          this.toast('已撤回隐私授权');
          router.back();
        }
      }
    });
  }

  private onRowAction(action: string): void {
    if (action === 'clear') {
      this.confirmClear();
    } else if (action === 'revoke') {
      this.confirmRevoke();
    } else if (action === 'privacy') {
      router.pushUrl({ url: 'pages/AgreementPage', params: { type: 'privacy' } });
    } else if (action === 'terms') {
      router.pushUrl({ url: 'pages/AgreementPage', params: { type: 'terms' } });
    }
  }

  @Builder
  RowList(rows: SettingRow[]) {
    Column() {
      ForEach(rows, (r: SettingRow, idx: number) => {
        Row({ space: 10 }) {
          Text(r.icon)
            .fontSize(18)
            .width(30)
          Column({ space: 2 }) {
            Text(r.title)
              .fontSize(14)
              .fontColor($r('app.color.c_text_primary'))
            if (r.desc.length > 0) {
              Text(r.desc)
                .fontSize(11)
                .fontColor($r('app.color.c_text_tertiary'))
            }
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('›')
            .fontSize(16)
            .fontColor($r('app.color.c_text_tertiary'))
        }
        .width('100%')
        .height(56)
        .onClick(() => {
          this.onRowAction(r.action);
        })
        .border(idx === rows.length - 1 ? {} : { width: { bottom: 1 }, color: $r('app.color.c_divider') })
      }, (r: SettingRow) => r.title)
    }
    .width('100%')
    .padding({ left: 14, right: 14 })
    .backgroundColor($r('app.color.c_card_bg'))
    .borderRadius(12)
  }

  build() {
    Column() {
      CommonTopBar({ title: '设置', showBack: true })

      Scroll() {
        Column({ space: 14 }) {
          // 数据与隐私
          this.RowList(DATA_ROWS)

          // 协议
          this.RowList(DOC_ROWS)

          // 关于
          Column({ space: 12 }) {
            Text('关于')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.c_text_primary'))
              .width('100%')
            Row() {
              Text('应用名称')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text('校膳通')
                .fontSize(13)
                .fontColor($r('app.color.c_text_primary'))
            }
            .width('100%')
            Row() {
              Text('版本号')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text(this.version)
                .fontSize(13)
                .fontColor($r('app.color.c_text_primary'))
            }
            .width('100%')
            Row() {
              Text('开发者')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text('校膳通开发团队')
                .fontSize(13)
                .fontColor($r('app.color.c_text_primary'))
            }
            .width('100%')
            Row() {
              Text('隐私授权状态')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text(this.privacyAgreed ? '已同意' : '未同意')
                .fontSize(13)
                .fontColor(this.privacyAgreed ? $r('app.color.c_success') : $r('app.color.c_danger'))
            }
            .width('100%')
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          Text('本应用为演示版本，应用内展示的食堂、窗口、菜品、排队与积分等数据均为演示数据，' +
            '不接入真实校园系统，也不产生真实交易。')
            .fontSize(11)
            .lineHeight(18)
            .fontColor($r('app.color.c_text_tertiary'))
            .width('100%')
            .padding({ left: 4, right: 4, bottom: 16 })
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