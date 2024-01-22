# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/user/Documents/Git/kzones/contents/ui/config.ui'
#
# Created by: PyQt5 UI code generator 5.15.9
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_KWin::KZonesConfigForm(object):
    def setupUi(self, KWin::KZonesConfigForm):
        KWin::KZonesConfigForm.setObjectName("KWin::KZonesConfigForm")
        KWin::KZonesConfigForm.resize(600, 600)
        self.verticalLayout = QtWidgets.QVBoxLayout(KWin::KZonesConfigForm)
        self.verticalLayout.setObjectName("verticalLayout")
        self.tabWidget = QtWidgets.QTabWidget(KWin::KZonesConfigForm)
        self.tabWidget.setTabPosition(QtWidgets.QTabWidget.North)
        self.tabWidget.setTabShape(QtWidgets.QTabWidget.Rounded)
        self.tabWidget.setIconSize(QtCore.QSize(16, 16))
        self.tabWidget.setElideMode(QtCore.Qt.ElideNone)
        self.tabWidget.setDocumentMode(False)
        self.tabWidget.setTabsClosable(False)
        self.tabWidget.setTabBarAutoHide(False)
        self.tabWidget.setObjectName("tabWidget")
        self.tab_general = QtWidgets.QWidget()
        self.tab_general.setObjectName("tab_general")
        self.verticalLayout_4 = QtWidgets.QVBoxLayout(self.tab_general)
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.groupBox_2 = QtWidgets.QGroupBox(self.tab_general)
        self.groupBox_2.setObjectName("groupBox_2")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.groupBox_2)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.kcfg_enableZoneIndicators = QtWidgets.QCheckBox(self.groupBox_2)
        self.kcfg_enableZoneIndicators.setChecked(True)
        self.kcfg_enableZoneIndicators.setObjectName("kcfg_enableZoneIndicators")
        self.verticalLayout_3.addWidget(self.kcfg_enableZoneIndicators)
        self.widget = QtWidgets.QWidget(self.groupBox_2)
        self.widget.setObjectName("widget")
        self.verticalLayout_10 = QtWidgets.QVBoxLayout(self.widget)
        self.verticalLayout_10.setContentsMargins(20, 0, 0, 6)
        self.verticalLayout_10.setObjectName("verticalLayout_10")
        self.kcfg_indicatorIsTarget = QtWidgets.QRadioButton(self.widget)
        self.kcfg_indicatorIsTarget.setChecked(True)
        self.kcfg_indicatorIsTarget.setObjectName("kcfg_indicatorIsTarget")
        self.verticalLayout_10.addWidget(self.kcfg_indicatorIsTarget)
        self.kcfg_zoneIsTarget = QtWidgets.QRadioButton(self.widget)
        self.kcfg_zoneIsTarget.setObjectName("kcfg_zoneIsTarget")
        self.verticalLayout_10.addWidget(self.kcfg_zoneIsTarget)
        self.verticalLayout_3.addWidget(self.widget)
        self.kcfg_enableZoneSelector = QtWidgets.QCheckBox(self.groupBox_2)
        self.kcfg_enableZoneSelector.setChecked(True)
        self.kcfg_enableZoneSelector.setObjectName("kcfg_enableZoneSelector")
        self.verticalLayout_3.addWidget(self.kcfg_enableZoneSelector)
        self.verticalLayout_4.addWidget(self.groupBox_2)
        self.groupBox_general = QtWidgets.QGroupBox(self.tab_general)
        self.groupBox_general.setObjectName("groupBox_general")
        self.verticalLayout_11 = QtWidgets.QVBoxLayout(self.groupBox_general)
        self.verticalLayout_11.setObjectName("verticalLayout_11")
        self.kcfg_rememberWindowGeometries = QtWidgets.QCheckBox(self.groupBox_general)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.kcfg_rememberWindowGeometries.sizePolicy().hasHeightForWidth())
        self.kcfg_rememberWindowGeometries.setSizePolicy(sizePolicy)
        self.kcfg_rememberWindowGeometries.setChecked(True)
        self.kcfg_rememberWindowGeometries.setObjectName("kcfg_rememberWindowGeometries")
        self.verticalLayout_11.addWidget(self.kcfg_rememberWindowGeometries)
        self.kcfg_invertedMode = QtWidgets.QCheckBox(self.groupBox_general)
        self.kcfg_invertedMode.setObjectName("kcfg_invertedMode")
        self.verticalLayout_11.addWidget(self.kcfg_invertedMode)
        self.verticalLayout_4.addWidget(self.groupBox_general)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout_4.addItem(spacerItem)
        self.groupBox_2.raise_()
        self.groupBox_general.raise_()
        icon = QtGui.QIcon.fromTheme("systemsettings")
        self.tabWidget.addTab(self.tab_general, icon, "")
        self.tab_layouts = QtWidgets.QWidget()
        self.tab_layouts.setObjectName("tab_layouts")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.tab_layouts)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.groupBox = QtWidgets.QGroupBox(self.tab_layouts)
        self.groupBox.setObjectName("groupBox")
        self.verticalLayout_6 = QtWidgets.QVBoxLayout(self.groupBox)
        self.verticalLayout_6.setObjectName("verticalLayout_6")
        self.kcfg_layoutsJson = QtWidgets.QPlainTextEdit(self.groupBox)
        self.kcfg_layoutsJson.setObjectName("kcfg_layoutsJson")
        self.verticalLayout_6.addWidget(self.kcfg_layoutsJson)
        self.verticalLayout_2.addWidget(self.groupBox)
        icon = QtGui.QIcon.fromTheme("preferences-desktop-virtual")
        self.tabWidget.addTab(self.tab_layouts, icon, "")
        self.tab_filters = QtWidgets.QWidget()
        self.tab_filters.setObjectName("tab_filters")
        self.verticalLayout_7 = QtWidgets.QVBoxLayout(self.tab_filters)
        self.verticalLayout_7.setObjectName("verticalLayout_7")
        self.groupBox_3 = QtWidgets.QGroupBox(self.tab_filters)
        self.groupBox_3.setObjectName("groupBox_3")
        self.verticalLayout_8 = QtWidgets.QVBoxLayout(self.groupBox_3)
        self.verticalLayout_8.setObjectName("verticalLayout_8")
        self.formLayout = QtWidgets.QFormLayout()
        self.formLayout.setObjectName("formLayout")
        self.label_2 = QtWidgets.QLabel(self.groupBox_3)
        self.label_2.setObjectName("label_2")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label_2)
        self.kcfg_filterMode = QtWidgets.QComboBox(self.groupBox_3)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.kcfg_filterMode.sizePolicy().hasHeightForWidth())
        self.kcfg_filterMode.setSizePolicy(sizePolicy)
        self.kcfg_filterMode.setObjectName("kcfg_filterMode")
        self.kcfg_filterMode.addItem("")
        self.kcfg_filterMode.addItem("")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.kcfg_filterMode)
        self.label_18 = QtWidgets.QLabel(self.groupBox_3)
        self.label_18.setObjectName("label_18")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label_18)
        self.kcfg_filterList = QtWidgets.QPlainTextEdit(self.groupBox_3)
        self.kcfg_filterList.setObjectName("kcfg_filterList")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.kcfg_filterList)
        self.verticalLayout_8.addLayout(self.formLayout)
        self.verticalLayout_7.addWidget(self.groupBox_3)
        icon = QtGui.QIcon.fromTheme("preferences-desktop-filter")
        self.tabWidget.addTab(self.tab_filters, icon, "")
        self.tab_shortcuts = QtWidgets.QWidget()
        self.tab_shortcuts.setObjectName("tab_shortcuts")
        self.verticalLayout_9 = QtWidgets.QVBoxLayout(self.tab_shortcuts)
        self.verticalLayout_9.setObjectName("verticalLayout_9")
        self.verticalLayout_5 = QtWidgets.QVBoxLayout()
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.groupBox_4 = QtWidgets.QGroupBox(self.tab_shortcuts)
        self.groupBox_4.setObjectName("groupBox_4")
        self.verticalLayout_12 = QtWidgets.QVBoxLayout(self.groupBox_4)
        self.verticalLayout_12.setObjectName("verticalLayout_12")
        self.label_23 = QtWidgets.QLabel(self.groupBox_4)
        self.label_23.setAlignment(QtCore.Qt.AlignCenter)
        self.label_23.setObjectName("label_23")
        self.verticalLayout_12.addWidget(self.label_23)
        self.verticalLayout_5.addWidget(self.groupBox_4)
        self.verticalLayout_9.addLayout(self.verticalLayout_5)
        icon = QtGui.QIcon.fromTheme("configure-shortcuts")
        self.tabWidget.addTab(self.tab_shortcuts, icon, "")
        self.tab_advanced = QtWidgets.QWidget()
        self.tab_advanced.setObjectName("tab_advanced")
        self.verticalLayout_91 = QtWidgets.QVBoxLayout(self.tab_advanced)
        self.verticalLayout_91.setObjectName("verticalLayout_91")
        self.verticalLayout_51 = QtWidgets.QVBoxLayout()
        self.verticalLayout_51.setObjectName("verticalLayout_51")
        self.groupBox_7 = QtWidgets.QGroupBox(self.tab_advanced)
        self.groupBox_7.setFlat(False)
        self.groupBox_7.setObjectName("groupBox_7")
        self.verticalLayout_16 = QtWidgets.QVBoxLayout(self.groupBox_7)
        self.verticalLayout_16.setObjectName("verticalLayout_16")
        self.formLayout_3 = QtWidgets.QFormLayout()
        self.formLayout_3.setObjectName("formLayout_3")
        self.label_4 = QtWidgets.QLabel(self.groupBox_7)
        self.label_4.setObjectName("label_4")
        self.formLayout_3.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label_4)
        self.kcfg_pollingRate = QtWidgets.QSpinBox(self.groupBox_7)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.kcfg_pollingRate.sizePolicy().hasHeightForWidth())
        self.kcfg_pollingRate.setSizePolicy(sizePolicy)
        self.kcfg_pollingRate.setMinimum(10)
        self.kcfg_pollingRate.setMaximum(1000)
        self.kcfg_pollingRate.setSingleStep(10)
        self.kcfg_pollingRate.setProperty("value", 100)
        self.kcfg_pollingRate.setObjectName("kcfg_pollingRate")
        self.formLayout_3.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.kcfg_pollingRate)
        self.verticalLayout_16.addLayout(self.formLayout_3)
        self.verticalLayout_51.addWidget(self.groupBox_7)
        self.groupBox_8 = QtWidgets.QGroupBox(self.tab_advanced)
        self.groupBox_8.setObjectName("groupBox_8")
        self.verticalLayout_17 = QtWidgets.QVBoxLayout(self.groupBox_8)
        self.verticalLayout_17.setObjectName("verticalLayout_17")
        self.kcfg_enableDebugMode = QtWidgets.QCheckBox(self.groupBox_8)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.kcfg_enableDebugMode.sizePolicy().hasHeightForWidth())
        self.kcfg_enableDebugMode.setSizePolicy(sizePolicy)
        self.kcfg_enableDebugMode.setObjectName("kcfg_enableDebugMode")
        self.verticalLayout_17.addWidget(self.kcfg_enableDebugMode)
        self.verticalLayout_51.addWidget(self.groupBox_8)
        self.verticalLayout_91.addLayout(self.verticalLayout_51)
        spacerItem1 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout_91.addItem(spacerItem1)
        icon = QtGui.QIcon.fromTheme("applications-development")
        self.tabWidget.addTab(self.tab_advanced, icon, "")
        self.verticalLayout.addWidget(self.tabWidget)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label_25 = QtWidgets.QLabel(KWin::KZonesConfigForm)
        self.label_25.setOpenExternalLinks(True)
        self.label_25.setObjectName("label_25")
        self.horizontalLayout.addWidget(self.label_25)
        self.label_13 = QtWidgets.QLabel(KWin::KZonesConfigForm)
        font = QtGui.QFont()
        font.setBold(False)
        font.setItalic(False)
        font.setUnderline(False)
        font.setWeight(50)
        font.setStrikeOut(False)
        self.label_13.setFont(font)
        self.label_13.setToolTip("")
        self.label_13.setScaledContents(False)
        self.label_13.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.label_13.setObjectName("label_13")
        self.horizontalLayout.addWidget(self.label_13)
        self.verticalLayout.addLayout(self.horizontalLayout)

        self.retranslateUi(KWin::KZonesConfigForm)
        self.tabWidget.setCurrentIndex(0)
        self.kcfg_enableZoneIndicators.toggled['bool'].connect(self.widget.setEnabled) # type: ignore
        QtCore.QMetaObject.connectSlotsByName(KWin::KZonesConfigForm)

    def retranslateUi(self, KWin::KZonesConfigForm):
        _translate = QtCore.QCoreApplication.translate
        self.groupBox_2.setTitle(_translate("KWin::KZonesConfigForm", "Overlay"))
        self.kcfg_enableZoneIndicators.setText(_translate("KWin::KZonesConfigForm", "Show zones when I start moving a window"))
        self.kcfg_indicatorIsTarget.setText(_translate("KWin::KZonesConfigForm", "Highlight zone when hovering over the indicator"))
        self.kcfg_zoneIsTarget.setText(_translate("KWin::KZonesConfigForm", "Highlight zone when the cursor is anywhere in the zone"))
        self.kcfg_enableZoneSelector.setText(_translate("KWin::KZonesConfigForm", "Show zone selector when I drag a window to the top of the screen"))
        self.groupBox_general.setTitle(_translate("KWin::KZonesConfigForm", "Behaviour"))
        self.kcfg_rememberWindowGeometries.setText(_translate("KWin::KZonesConfigForm", "Remember and restore window geometries"))
        self.kcfg_invertedMode.setToolTip(_translate("KWin::KZonesConfigForm", "When enabled, moving windows will not trigger the osd. Instead you\'ll have to use the \"Toggle OSD\" shortcut to show the osd."))
        self.kcfg_invertedMode.setText(_translate("KWin::KZonesConfigForm", "Require shortcut to show overlay"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_general), _translate("KWin::KZonesConfigForm", "General"))
        self.groupBox.setTitle(_translate("KWin::KZonesConfigForm", "Layouts"))
        self.kcfg_layoutsJson.setPlainText(_translate("KWin::KZonesConfigForm", "[\n"
"    {\n"
"        \"name\": \"Priority Grid\",\n"
"        \"padding\": 0,\n"
"        \"zones\": [\n"
"            {\n"
"                \"x\": 0,\n"
"                \"y\": 0,\n"
"                \"height\": 100,\n"
"                \"width\": 25\n"
"            },\n"
"            {\n"
"                \"x\": 25,\n"
"                \"y\": 0,\n"
"                \"height\": 100,\n"
"                \"width\": 50\n"
"            },\n"
"            {\n"
"                \"x\": 75,\n"
"                \"y\": 0,\n"
"                \"height\": 100,\n"
"                \"width\": 25\n"
"            }\n"
"        ]\n"
"    },\n"
"    {\n"
"        \"name\": \"Quadrant Grid\",\n"
"        \"zones\": [\n"
"            {\n"
"                \"x\": 0,\n"
"                \"y\": 0,\n"
"                \"height\": 50,\n"
"                \"width\": 50\n"
"            },\n"
"            {\n"
"                \"x\": 0,\n"
"                \"y\": 50,\n"
"                \"height\": 50,\n"
"                \"width\": 50\n"
"            },\n"
"            {\n"
"                \"x\": 50,\n"
"                \"y\": 50,\n"
"                \"height\": 50,\n"
"                \"width\": 50\n"
"            },\n"
"            {\n"
"                \"x\": 50,\n"
"                \"y\": 0,\n"
"                \"height\": 50,\n"
"                \"width\": 50\n"
"            }\n"
"        ]\n"
"    }\n"
"]"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_layouts), _translate("KWin::KZonesConfigForm", "Layouts"))
        self.groupBox_3.setTitle(_translate("KWin::KZonesConfigForm", "Filtering"))
        self.label_2.setText(_translate("KWin::KZonesConfigForm", "Mode"))
        self.kcfg_filterMode.setItemText(0, _translate("KWin::KZonesConfigForm", "Include"))
        self.kcfg_filterMode.setItemText(1, _translate("KWin::KZonesConfigForm", "Exclude"))
        self.label_18.setText(_translate("KWin::KZonesConfigForm", "Filter"))
        self.kcfg_filterList.setToolTip(_translate("KWin::KZonesConfigForm", "Enter window classes you wish to include/exclude (seperated by a new line)"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_filters), _translate("KWin::KZonesConfigForm", "Filters"))
        self.groupBox_4.setTitle(_translate("KWin::KZonesConfigForm", "Shortcuts"))
        self.label_23.setText(_translate("KWin::KZonesConfigForm", "<html><head/><body><p>To set up shortcuts for this script</p><p>Go to System Settings / Shortcuts and search for &quot;KZones&quot;</p></body></html>"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_shortcuts), _translate("KWin::KZonesConfigForm", "Shortcuts"))
        self.groupBox_7.setTitle(_translate("KWin::KZonesConfigForm", "Performance"))
        self.label_4.setToolTip(_translate("KWin::KZonesConfigForm", "Speed of which the zone checking is done"))
        self.label_4.setText(_translate("KWin::KZonesConfigForm", "Polling rate"))
        self.kcfg_pollingRate.setToolTip(_translate("KWin::KZonesConfigForm", "Speed of which the zone checking is done"))
        self.kcfg_pollingRate.setSuffix(_translate("KWin::KZonesConfigForm", " ms"))
        self.groupBox_8.setTitle(_translate("KWin::KZonesConfigForm", "Debug"))
        self.kcfg_enableDebugMode.setText(_translate("KWin::KZonesConfigForm", "Enable debug mode"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.tab_advanced), _translate("KWin::KZonesConfigForm", "Advanced"))
        self.label_25.setToolTip(_translate("KWin::KZonesConfigForm", "https://github.com/gerritdevriese/kzones"))
        self.label_25.setText(_translate("KWin::KZonesConfigForm", "<a href=\"https://github.com/gerritdevriese/kzones\">Github page</a>"))
        self.label_13.setText(_translate("KWin::KZonesConfigForm", "Please reload the script after making changes to apply them"))
