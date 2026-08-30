#!/usr/bin/env python3
import os, sys, http.server, urllib.parse
import subprocess
import threading

_lock = threading.Lock()
_proc: subprocess.Popen | None = None
dir = "./stable"
branch = "master"
secret = os.environ.get('SECRET')
timer = None

def reload(reason):
    global _proc
    with _lock:
        if _proc is not None and _proc.poll() is None:
            print("Reload request for", reason, "failed (already running)")
            return  # still running — skip
        print("Rebuilding:", reason)
        _proc = subprocess.Popen("./run.sh", start_new_session=True)   
        global timer
        if timer is not None:
            timer.cancel()
        timer = threading.Timer(1800, reload, args=["Timer"])
        timer.start()


class SimpleHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=dir, **kwargs)
    def do_GET(self):
        if self.path.startswith("/_builder/"):
            u = urllib.parse.urlsplit(self.path)
            if u.path == "/_builder/ping":
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'Pong')
                return
            elif u.path == "/_builder/reload":
                if secret and secret != u.query:
                    self.send_response(403)
                    self.end_headers()
                    self.wfile.write(b'403 Forbidden')
                    return
                reload("HTTP Request")
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'OK')
                return

            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"404 Not found")
            return

        return http.server.SimpleHTTPRequestHandler.do_GET(self)

port = sys.argv[1] if len(sys.argv) > 1 else 3000
print("serving at http://127.0.0.1:{}".format(port))
reload("booted")
server = http.server.ThreadingHTTPServer(("0.0.0.0", int(port)), SimpleHTTPRequestHandler)
server.serve_forever()
