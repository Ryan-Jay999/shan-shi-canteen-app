import { router } from '@kit.ArkUI';
import { CrowdLevel, levelBg, levelColor, levelText } from './Model';

// 拥挤程度小标签
@Component
export struct LevelTag {
  @Prop level: CrowdLevel = CrowdLevel.Free;

  build() {
    Text(levelText(this.level))
      .fontSize(11)
      .fontColor(levelColor(this.level))
      .backgroundColor(levelBg(this.level))
      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
      .borderRadius(6)
  }
}

// 菜品数量加减控件
@Component
export struct DishCounter {
  @Prop qty: number = 0;
  onAdd: () => void = () => {};
  onMinus: () => void = () => {};

  build() {
    Row() {
      if (this.qty > 0) {
        Button('−')
          .fontSize(16)
          .fontColor('#FF6B35')
          .backgroundColor('#FFF0E8')
          .width(26)
          .height(26)
          .borderRadius(13)
          .padding(0)
          .onClick(() => {
            this.onMinus();
          })
        Text(this.qty.toString())
          .fontSize(14)
          .fontColor('#333333')
          .width(28)
          .textAlign(TextAlign.Center)
      }
      Button('+')
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('#FF6B35')
        .width(26)
        .height(26)
        .borderRadius(13)
        .padding(0)
        .onClick(() => {
          this.onAdd();
        })
    }
  }
}

// 二级页通用导航栏
@Component
export struct CommonTopBar {
  @Prop title: string = '';
  showBack: boolean = true;

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#222222')
        .width('100%')
        .textAlign(TextAlign.Center)
      if (this.showBack) {
        Text('‹')
          .fontSize(30)
          .fontColor('#333333')
          .margin({ left: 12 })
          .onClick(() => {
            router.back();
          })
      }
    }
    .width('100%')
    .height(48)
    .backgroundColor(Color.White)
  }
}

// 分组小标题
@Component
export struct SectionTitle {
  @Prop text: string = '';
  @Prop extra: string = '';

  build() {
    Row() {
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
      Blank()
      if (this.extra.length > 0) {
        Text(this.extra)
          .fontSize(12)
          .fontColor('#999999')
      }
    }
    .width('100%')
  }
}
