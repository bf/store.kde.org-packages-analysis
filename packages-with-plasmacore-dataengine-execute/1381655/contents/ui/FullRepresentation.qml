import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "lib"
import "lib/TimeUtils.js" as TimeUtils

IssueListView {
	id: issueListView

	isSetup: widget.repoStringList.length >= 1
	showHeading: plasmoid.configuration.showHeading
	headingText: {
		if (plasmoid.configuration.headingText) {
			return plasmoid.configuration.headingText
		} else {
			return widget.repoStringList.join(', ')
		}
	}

	delegate: IssueListItem {
		issueOpen: issue.state == 'opened'
		issueId: issue.iid
		issueSummary: issue.title
		property bool isPullRequest: typeof issue.merge_status !== "undefined"
		category: {
			if (widget.repoStringList.length >= 2) {
				if (isPullRequest) {
					return issue.references.full.split('!')[0] // kde/kdeconnect-kde!258
				} else {
					return issue.references.full.split('#')[0] // kde/kdeconnect-kde#23
				}
			} else {
				return ""
			}
		}
		issueCreatorName: issue.author.username
		issueHtmlLink: issue.web_url
		showNumComments: issue.user_notes_count > 0
		numComments: issue.user_notes_count

		dateTime: {
			if (isPullRequest) {
				if (issue.state == 'opened') {
					return issue.created_at
				} else if (issue.state == 'merged') {
					return issue.merged_at
				} else if (issue.state == 'locked') {
					return issue.created_at
				} else { // 'closed'
					return issue.closed_at
				}
			} else {
				if (issue.state == 'opened') {
					return issue.created_at
				} else { // 'closed'
					return issue.closed_at
				}
			}
		}

		issueState: {
			if (isPullRequest) {
				if (issue.state == 'opened') {
					return 'openPullRequest'
				} else if (issue.state == 'merged') {
					return 'merged'
				// } else if (issue.state == 'locked') {
				// 	return '...'
				} else { // 'closed'
					return 'closedPullRequest'
				}
			} else {
				if (issue.state == 'opened') {
					return 'opened'
				} else { // 'closed'
					return 'closed'
				}
			}
		}
	}
}
