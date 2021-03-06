//
//  Actions.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public protocol Action: Encodable {
    /// The action for the speaker
    var action: String { get }
}

public protocol Request: Action {
    associatedtype ResponseType
}

extension Action {
    var jsonString: String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}


public struct Actions {
    /// Join the Orthoplay system
    public struct GlobalJoin: Request {
        public typealias ResponseType = Responses.GlobalJoined
        public let action: String  = "global_join"
        /// Major protocol version.
        public let protocolMajorVersion: Int
        /// Minor protocol version.
        public let protocolMinorVersion: Int
        // Coding Keys
        private enum CodingKeys: String, CodingKey {
            case action
            case protocolMajorVersion = "protocol_major_version"
            case protocolMinorVersion = "protocol_minor_version"
        }
    }
    
    /// Let the Orthoremote join the group
    public struct GroupJoin: Request {
        public typealias ResponseType = Responses.GroupJoined
        public let action: String  = "group_join"
        /// The index of the color from the color palette.
        public let colorIndex: Int
        /// The name of the user. Can be `guest` or Teenage ID.
        public let name: String
        /// Wether or not we want to receive Realtime updates. E.g. current position in a track.
        public let realtimeData: Bool
        /// A unique identifier for the remote
        public let uid: String
        
        private enum CodingKeys: String, CodingKey {
            case action
            case colorIndex = "color_index"
            case name
            case realtimeData = "realtime_data"
            case uid
        }
    }
    
    /// A ping to keep the connection to the OD-11 alive (and monitor latency).
    public struct SpeakerPing: Request {
        public typealias ResponseType = Responses.SpeakerPong
        public let action: String  = "speaker_ping"
        /// Any value that can be used to identify a corresponding pong.
        public let value: Int
    }
    
    /// Change the volume of the Group
    public struct ChangeVolume: Action {
        public let action: String = "group_change_volume"
        /// The amount by which the volume should be changed
        public let amount: Int
    }
    
    /// Set the volume of the Group
    public struct SetVolume: Action {
        public let action: String = "group_set_volume"
        /// The aboslute volume to set
        public let volume: Int
        // Coding Keys
        private enum CodingKeys: String, CodingKey {
            case volume = "vol"
        }
    }
    
    public struct SeekTrack: Action {
        public let action: String = "track_seek"
        // Todo check format
        public let time: TimeInterval
    }
    
    /// Start Playback. Equivalent to pressing the Play button.
    public struct StartPlayback: Action {
        public let action: String = "playback_start"
    }
    
    /// Stop Playback. Equivalent to pressing the Stop button.
    public struct StopPlayback: Action {
        public let action: String = "playback_stop"
    }
    
    /// Skip Track.
    public struct SkipTrackToNext: Action {
        public let action: String = "track_skip_to_next"
    }
    
    /// Skip Track to previous.
    public struct SkipTrackToPrev: Action {
        public let action: String = "track_skip_to_prev"
    }
    
    public struct SetBassBoost: Action {
        public let action: String = "group_set_eq_bass_boost"
        public let enabled: Bool
    }
    
    public struct SetTrebleBoost: Action {
        public let action: String = "group_eq_treble_boost"
        public let enabled: Bool
    }
    
    public struct SetMidBoost: Action {
        public let action: String = "group_set_eq_mid_boost"
        public let enabled: Bool
    }
    
    
    public struct PlayTestSound: Action {
        public let action: String = "speaker_play_test_sound"
        public let mac: String
    }
    
    public struct SetInputSource: Action {
        public let action: String = "group_set_input_source"
        public let source: Int
    }
    
    /// Set the color of the client remote.
    public struct SetClientColor: Action {
        public let action: String = "client_set_color"
        public let colorIndex: Int
        
        private enum CodingKeys: String,  CodingKey {
            case colorIndex = "color_index"
        }
    }
    
    /// Get more information about a client.
    public struct GetClientInfo: Request {
        public typealias ResponseType = Responses.ClientInfo
        public let action: String = "client_set_color"
        public let uid: String
    }
    
    
    
    
    // Playlist
    /// Request a part of the playlist.
    public struct PlaylistGetTracks: Request {
        public typealias ResponseType = Responses.PlaylistTracks
        public let action: String = "playlist_get_tracks"
        /// The playlist revision.
        public let revision: Int
        /// The number of items.
        public let items: Int
        /// The start Index.
        public let start: Int
        
        private enum CodingKeys: String, CodingKey {
            case action
            case revision = "list_revision"
            case items = "num_items"
            case start = "start_index"
        }
    }
    
    /// Add a URL to the playlist.
    public struct PlaylistAddURL: Action {
        public let action: String = "playlist_add_url"
        /// The URL to be added to the playlist.
        public let url: URL
    }
    
    // Speaker Actions
    /// Set the Mute state for the Speaker
    public struct SetMuteState: Action {
        public let action: String = "speaker_set_mute_state"
        public let mac: String
        public let muted: Bool
    }
    /// Set the Channel for the Speaker
    public struct SetChannel: Action {
        public let action: String = "speaker_set_channel"
        public let channel: Speaker.Channel
        public let mac: String
    }
    
    
    
    // Group Actions
    /// Move a speaker to a new Group and assign a name to that Group
    public struct MoveToNewGroup: Action {
        public let action: String = "speaker_move_to_new_group"
        public let groupName: String
        public let mac: String
        
        private enum CodingKeys: String, CodingKey {
            case action
            case groupName = "group_name"
            case mac
        }
    }
    
    /// Move a speaker to an existing Group
    public struct MoveToExistingGroup: Action {
        public let action: String = "speaker_move_to_existing_group"
        public let groupId: String
        public let mac: String
        
        private enum CodingKeys: String, CodingKey {
            case action
            case groupId = "group_id"
            case mac
        }
    }
    /// Change the name of a Speaker Group
    public struct SetGroupName: Action {
        public let action: String = "group_set_name"
        public let groupId: String
        public let groupName: String
        
        private enum CodingKeys: String, CodingKey {
            case action
            case groupId = "group_id"
            case groupName = "group_name"
        }
    }
    
    
    /// Perform a Factory Reset (Needs )
    public struct FactoryReset: Action {
        public let action: String = "factory_reset"
    }
}

