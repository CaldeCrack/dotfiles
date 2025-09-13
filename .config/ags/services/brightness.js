import GObject from "gi://GObject";
import { exec, execAsync } from "ags/process";
import { monitorFile } from "ags/file";

const BrightnessService = GObject.registerClass(
  {
    Signals: {
      "screen-changed": { param_types: [GObject.TYPE_DOUBLE] },
    },
    Properties: {
      // name, nick, blurb, flags, min, max, default
      "screen-value": GObject.ParamSpec.double(
        "screen-value",
        "Screen Value",
        "Screen brightness value (0..1)",
        GObject.ParamFlags.READWRITE,
        0.0,
        1.0,
        0.0,
      ),
    },
  },
  class BrightnessService extends GObject.Object {
    _init(props = {}) {
      super._init(props);

      // private-like fields
      this._screenValue = 0;
      this._interface = exec(
        "sh -c 'ls -w1 /sys/class/backlight | head -1'",
      ).trim();
      this._max = Number(exec("brightnessctl max"));

      // monitor file and seed initial value
      const path = `/sys/class/backlight/${this._interface}/brightness`;
      monitorFile(path, () => this._onChange());
      this._onChange();
    }

    // getter/setter names kept snake_case so bindings/hook conventions match
    get screen_value() {
      return this._screenValue;
    }

    set screen_value(percent) {
      if (percent <= 0) percent = 0.01;
      if (percent > 1) percent = 1;

      this._screenValue = percent;
      this.notify("screen-value");
      this.emit("screen-changed", percent);

      execAsync(`brightnessctl set ${percent * 100}% -q`);
    }

    _onChange() {
      this._screenValue = Number(exec("brightnessctl get")) / this._max;

      this.notify("screen-value");
      this.emit("screen-changed", this._screenValue);
    }
  },
);

const service = new BrightnessService();
export default service;
