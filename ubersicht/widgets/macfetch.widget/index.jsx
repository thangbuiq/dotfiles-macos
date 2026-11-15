import { React } from "uebersicht";

export const command = `
user=$(whoami)
host=$(scutil --get ComputerName 2>/dev/null || hostname -s)
osver=$(sw_vers -productVersion)
osname=$(sw_vers -productName)
model=$(sysctl -n hw.model 2>/dev/null)
kernel=$(uname -r)
up=$(uptime | sed -E 's/.*up ([^,]*,[^,]*),.*/\\1/' | sed -E 's/^ +//')
shellname=$(basename "$SHELL")
term="\${TERM_PROGRAM:-unknown}"
cpu=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
res=$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Resolution/ {print $2; exit}')

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
disk=$(df -H /System/Volumes/Data | awk 'NR==2 {print $3" / "$2}')
batt=$(system_profiler SPPowerDataType 2>/dev/null | awk '/Cycle Count/ {c=$3} /Maximum Capacity/ {m=$3} END {print m" health, "c" cycles"}')
ip=$(ipconfig getifaddr en0 2>/dev/null || echo "offline")
py=$(python3 --version 2>/dev/null | awk '{print $2}')
node=$(node -v 2>/dev/null | tr -d v)

printf '%s\\n' \\
  "user::$user" \\
  "host::$host" \\
  "os::$osname $osver" \\
  "model::$model" \\
  "kernel::$kernel" \\
  "uptime::$up" \\
  "shell::$shellname" \\
  "term::$term" \\
  "cpu::$cpu" \\
  "res::$res" \\
  "disk::$disk" \\
  "battery::$batt" \\
  "ip::$ip" \\
  "python::$py" \\
  "node::$node"
`;

// Run once at load: nothing here changes often enough to poll.
export const refreshFrequency = false;

export const className = `
  left: 83px;
  bottom: 20px;
  width: 654px;
  height: 272px;
  box-sizing: border-box;
  font-family: "JetBrainsMono Nerd Font Mono", monospace;
  font-size: 12px;
  line-height: 1.5;
  color: #cdd6f4;
  background: rgba(30, 30, 46, 0.8);
  border: 1px solid #45475a;
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  padding: 22px 28px;
  border-radius: 0;

  .row {
    display: flex;
  }

  .logo {
    white-space: pre;
    font-weight: normal;
    font-size: 9px;
    line-height: 1.2;
    letter-spacing: 0.3px;
    margin-right: 28px;
  }
  .logo .l1 { color: #cba6f7; }
  .logo .l2 { color: #cba6f7; }
  .logo .l3 { color: #cba6f7; }
  .logo .l4 { color: #cba6f7; }
  .logo .l5 { color: #cba6f7; }
  .logo .l6 { color: #cba6f7; }
  .logo .l7 { color: #cba6f7; }
  .logo .l8 { color: #cba6f7; }

  .info {
    white-space: pre;
  }

  .title {
    color: #cdd6f4;
    font-weight: bold;
  }

  .rule {
    color: #45475a;
  }

  .key {
    color: #cba6f7;
    font-weight: bold;
  }

  .val {
    color: #cdd6f4;
  }

  .swatches {
    display: flex;
    margin-top: 12px;
  }
  .swatches div {
    width: 22px;
    height: 16px;
  }
`;

const APPLE_LOGO = [
  ["l1", "                    'c."],
  ["l2", "                 ,xNMM."],
  ["l2", "               .OMMMMo"],
  ["l2", "               OMMM0,"],
  ["l3", "     .;loddo:' loolloddol;."],
  ["l3", "   cKMMMMMMMMMMNWMMMMMMMMMM0:"],
  ["l4", " .KMMMMMMMMMMMMMMMMMMMMMMMWd."],
  ["l4", " XMMMMMMMMMMMMMMMMMMMMMMMX."],
  ["l4", ";MMMMMMMMMMMMMMMMMMMMMMMM:"],
  ["l5", ":MMMMMMMMMMMMMMMMMMMMMMMM:"],
  ["l5", ".MMMMMMMMMMMMMMMMMMMMMMMMX."],
  ["l5", " kMMMMMMMMMMMMMMMMMMMMMMMMWd."],
  ["l6", ".XMMMMMMMMMMMMMMMMMMMMMMMMMMk"],
  ["l6", "  .XMMMMMMMMMMMMMMMMMMMMMMMMK."],
  ["l7", "    kMMMMMMMMMMMMMMMMMMMMMMd"],
  ["l7", "     ;KMMMMMMMWXXWMMMMMMMk."],
  ["l8", "       .cooc,.    .,coo:."],
];

const SWATCH_COLORS = [
  "#f38ba8", "#fab387", "#f9e2af", "#a6e3a1",
  "#89b4fa", "#cba6f7",
];

const parse = (output) => {
  const map = {};
  (output || "").split("\n").forEach((line) => {
    const idx = line.indexOf("::");
    if (idx === -1) return;
    map[line.slice(0, idx)] = line.slice(idx + 2).trim();
  });
  return map;
};

const Row = ({ label, value }) => (
  <div>
    <span className="key">{label}</span>
    <span className="val">: {value}</span>
  </div>
);

export const render = ({ output, error }) => {
  const d = parse(output);

  return (
    <div className="row">
      <div className="logo">
        {APPLE_LOGO.map((l, i) => (
          <div key={i} className={l[0]}>{l[1]}</div>
        ))}
      </div>
      <div className="info">
        {error ? (
          <div className="val">error running command</div>
        ) : (
          <>
            <Row label="OS" value={d.os} />
            <Row label="Kernel" value={d.kernel} />
            <Row label="Uptime" value={d.uptime} />
            <Row label="Shell" value={d.shell} />
            <Row label="Resolution" value={d.res} />
            <Row label="CPU" value={d.cpu} />
            <Row label="Disk" value={d.disk} />
            <Row label="Battery" value={d.battery} />
            <Row label="Local IP" value={d.ip} />
            <Row label="Python" value={d.python} />
            <Row label="Node" value={d.node} />
          </>
        )}
        <div className="swatches">
          {SWATCH_COLORS.map((c, i) => (
            <div key={i} style={{ background: c }} />
          ))}
        </div>
      </div>
    </div>
  );
};
