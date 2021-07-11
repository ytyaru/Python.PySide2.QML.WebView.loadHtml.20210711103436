#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys, numpy, pyopenjtalk
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl, QObject, Slot, Property, QThread, Signal, QMutex, QMutexLocker
import simpleaudio as sa
import feedparser
import pprint

ENGINE = None
class Connect(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.__ply = None
        self.__feed = None
    @Slot(str)
    def talk(self, text): self.__talk_async(text)
    def __talk_async(self, text):
        x, sr = pyopenjtalk.tts(text)
        if self.__ply and self.__ply.is_playing():
            self.__ply.stop()
            self.__ply = None
        self.__ply = sa.play_buffer(x.astype(numpy.int16), 1, 2, sr)
    def __talk(self, text, is_split=True):
        if is_split: self.__talk_split(text)
        else:
            self.__talk_async(text)
            self.__ply.wait_done()
    def __talk_split(self, text):
        for sentence in [line for line in text.split('。') if 0 < len(line)]:
            self.__talk_async(text)
            self.__ply.wait_done()
    @Slot(str)
    def talk_news(self, url):
        if not self.__feed: 
            self.__feed = feedparser.parse(url)
        pprint.pprint(self.__feed, depth=1)
        pprint.pprint(self.__feed['feed'], depth=1)
        news_num = len(self.__feed['entries'])
        print(news_num)
#        self.__talk_async(f'{news_num}件のニュースがあります。')
        self.__talk(f'{news_num}件のニュースがあります。')
        for entry in self.__feed['entries']:
            pprint.pprint(entry, depth=1)
            self.__talk(entry.title)
#            self.__talk(entry.summary)
        """
        """
    @Slot(str, result=str)
    def make_html(self, url):
        html = ''
        self.__feed = feedparser.parse(url)
        html += f'<ul>'
        for entry in self.__feed['entries']:
#            html += f'<li><a href="{entry.link}">{entry.title}</a><details><summary>概要</summary>{entry.summary}</details></li>'
            html += f'<li><a href="{entry.link}">{entry.title}</a><p>{entry.summary}</p></li>'
        html += f'</ul>'
        return html


class TestProcess(QThread):
    printThread = Signal(str)
    def __init__(self, parent=None):
        QThread.__init__(self, parent)
        self.mutex = QMutex()
        self.stopped = False
    def __del__(self):
        self.stop()
        self.wait()
    def stop(self):
        with QMutexLocker(self.mutex):
            self.stopped = True
    def restart(self):
        with QMutexLocker(self.mutex):
            self.stopped = False
    def run(self):
        countNum = 0
        while not self.stopped:
            self.printThread.emit(str(countNum))
            countNum += 1
            time.sleep(1)

def Main():
    app = QApplication(sys.argv)
    connect = Connect()
    engine = QQmlApplicationEngine()
    ctx = engine.rootContext()
    ctx.setContextProperty("Connect", connect)
    HERE = os.path.dirname(os.path.abspath(__file__))
    UI = os.path.join(HERE, 'talker.qml')
    engine.load(UI)
    ENGINE = engine
    if not engine.rootObjects(): sys.exit(-1)
    sys.exit(app.exec_())

if __name__ == '__main__':
    Main()
